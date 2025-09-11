package alloy.language.server.document;

import alloy.language.server.AlloyLanguageClient;
import alloy.language.server.utils.AlloyInstanceUtils;
import alloy.language.server.utils.data.ParsingErrorCursor;
import edu.mit.csail.sdg.alloy4.Err;
import edu.mit.csail.sdg.parser.CompModule;
import edu.mit.csail.sdg.translator.A4Solution;
import org.eclipse.lsp4j.*;
import org.slf4j.Logger;

import java.util.ArrayList;
import java.util.List;

public class AlloyDocumentModel {
    private static final Logger logger = org.slf4j.LoggerFactory.getLogger(AlloyDocumentModel.class);

	private final AlloyLanguageClient client;
	private final String documentURI;

	private String documentText;
	private CompModule model;
	private A4Solution defaultSolution;
	private boolean hasErrors;

	public AlloyDocumentModel(String documentURI, String documentText, AlloyLanguageClient client) {
		this.documentURI = documentURI;
		this.documentText = documentText;
		this.client = client;
		this.hasErrors = true;

		updateModel();
	}

	public AlloyDocumentModel(String documentURI, String documentText) {
		this(documentURI, documentText, null);
	}

	public AlloyDocumentModel(TextDocumentItem textDocumentItem) {
		this(textDocumentItem.getUri(), textDocumentItem.getText());
	}

	public void documentChanged(String changedContent) {
		this.documentText = changedContent;
		updateModel();
	}

	public void documentSaved(String savedContent) {
		this.documentText = savedContent;
		updateModel();
	}

	public String getDocumentURI() {
		return documentURI;
	}

	public String getDocumentText() {
		return documentText;
	}

	public CompModule getModel() {
		return model;
	}

	public A4Solution getDefaultSolution() {
		return defaultSolution;
	}

	public boolean hasErrors() {return hasErrors;}

	private void updateModel() {
		try {
			var result = AlloyInstanceUtils.buildAlloyModelWithErrorListing(documentText);
			this.model = result.a;
			this.defaultSolution = AlloyInstanceUtils.buildInstance(model);

			if (client != null) {
				if (result.b != null && !result.b.isEmpty()) {
					hasErrors = true;
					var errors = result.b;
					List<Diagnostic> diagnostics = new ArrayList<>();
					for (ParsingErrorCursor error : errors) {
						Diagnostic diagnostic = new Diagnostic();
						diagnostic.setRange(new Range(error.start, error.end));
						diagnostic.setMessage(error.message);
						diagnostic.setSeverity(DiagnosticSeverity.Error);
						diagnostics.add(diagnostic);
					}
					client.publishDiagnostics(new PublishDiagnosticsParams(this.documentURI, diagnostics));
				} else {
					hasErrors = false;
					client.publishDiagnostics(new PublishDiagnosticsParams(this.documentURI, new ArrayList<>()));
				}
			}

		} catch (Err ex) {
			hasErrors = true;
			logger.error("alloy model update failed for {}", ex.msg, ex);
			if (client != null) {
				Diagnostic diagnostic = new Diagnostic();
				Position start = new Position(ex.pos.y - 1, ex.pos.x);
				Position end = new Position(ex.pos.y2 - 1, ex.pos.x2);
				diagnostic.setRange(new Range(start, end));
				diagnostic.setMessage(ex.msg);
				diagnostic.setSeverity(DiagnosticSeverity.Error);
				List<Diagnostic> diagnostics = new ArrayList<>();
				diagnostics.add(diagnostic);
				client.publishDiagnostics(new PublishDiagnosticsParams(this.documentURI, diagnostics));
			}
		} catch (Exception ex) {
			logger.error("Unknown exception: {}", ex.getMessage(), ex);
		}
	}
}
