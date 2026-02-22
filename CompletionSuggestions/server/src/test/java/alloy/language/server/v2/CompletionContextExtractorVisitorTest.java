package alloy.language.server.v2;

import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.utils.CodeUtils;
import org.eclipse.lsp4j.*;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;

class CompletionContextExtractorVisitorTest {

	@Test
	public void testDotOp() {
		CompletionModelBuilder modelBuilder = CompletionModelBuilder.modelBuilder();
		modelBuilder.withContent("pred p1 {")
				.withCompletionLine("some p: Person | p.")
				.withContent("}");
		TextDocumentIdentifier textDocument = new TextDocumentIdentifier();
		CompletionContext completionContext = new CompletionContext(CompletionTriggerKind.TriggerCharacter, ".");
		Position position =
				new Position(modelBuilder.getCompletionLineNumber(), modelBuilder.getCompletionCharacterNumber()); // Line and character position where completion is triggered
		CompletionParams completionParams = new CompletionParams(textDocument, position, completionContext);

		var parser = CodeUtils.buildAlloyParser(modelBuilder.build());
		CompletionContextExtractorVisitor visitor = new CompletionContextExtractorVisitor(completionParams);
		var context = visitor.visit(parser.alloyModule());
		assertNotNull(context);
		assertThat(context.completionTerm().getText(), is("p"));
		assertThat(context.completionOperator().getText(), is("."));
	}

	@Test
	public void testBinOp() {
		CompletionModelBuilder modelBuilder = CompletionModelBuilder.modelBuilder();
		modelBuilder.withContent("pred p1 {")
				.withCompletionLine("some p: Person | p in  ")
				.withContent("}");
		TextDocumentIdentifier textDocument = new TextDocumentIdentifier();
		CompletionContext completionContext = new CompletionContext(CompletionTriggerKind.TriggerCharacter, "in");
		Position position =
				new Position(modelBuilder.getCompletionLineNumber(), modelBuilder.getCompletionCharacterNumber()); // Line and character position where completion is triggered
		CompletionParams completionParams = new CompletionParams(textDocument, position, completionContext);

		var parser = CodeUtils.buildAlloyParser(modelBuilder.build());
		CompletionContextExtractorVisitor visitor = new CompletionContextExtractorVisitor(completionParams);
		var context = visitor.visit(parser.alloyModule());
		assertNotNull(context);
		assertThat(context.completionTerm().getText(), is("p"));
		assertThat(context.completionOperator().getText(), is("in"));
	}

	@Test
	public void testMultipleBinOp() {
		CompletionModelBuilder modelBuilder = CompletionModelBuilder.modelBuilder();
		modelBuilder.withContent("pred p1 {")
				.withCompletionLine("some p: Person | p in Person and p not in")
				.withContent("}");
		TextDocumentIdentifier textDocument = new TextDocumentIdentifier();
		CompletionContext completionContext = new CompletionContext(CompletionTriggerKind.TriggerCharacter, "in");
		Position position =
				new Position(modelBuilder.getCompletionLineNumber(), modelBuilder.getCompletionCharacterNumber()); // Line and character position where completion is triggered
		CompletionParams completionParams = new CompletionParams(textDocument, position, completionContext);

		var parser = CodeUtils.buildAlloyParser(modelBuilder.build());
		CompletionContextExtractorVisitor visitor = new CompletionContextExtractorVisitor(completionParams);
		var context = visitor.visit(parser.alloyModule());
		assertNotNull(context);
		assertThat(context.completionTerm().getText(), is("p"));
		assertThat(context.completionOperator().getText(), is("in"));
	}

	//some p: Person | p in Person and p.
	@Test
	public void testBinOpAndDotOp() {
		CompletionModelBuilder modelBuilder = CompletionModelBuilder.modelBuilder();
		modelBuilder.withContent("pred p1 {")
				.withCompletionLine("some p: Person | p in Person and p.q.")
				.withContent("}");
		TextDocumentIdentifier textDocument = new TextDocumentIdentifier();
		CompletionContext completionContext = new CompletionContext(CompletionTriggerKind.TriggerCharacter, ".");
		Position position =
				new Position(modelBuilder.getCompletionLineNumber(), modelBuilder.getCompletionCharacterNumber()); // Line and character position where completion is triggered
		CompletionParams completionParams = new CompletionParams(textDocument, position, completionContext);

		var parser = CodeUtils.buildAlloyParser(modelBuilder.build());
		CompletionContextExtractorVisitor visitor = new CompletionContextExtractorVisitor(completionParams);
		var context = visitor.visit(parser.alloyModule());
		assertNotNull(context);
		assertThat(context.completionTerm().getText(), is("p.q"));
		assertThat(context.completionOperator().getText(), is("."));
	}

	//fun po_loc : MemoryEvent->MemoryEvent { ^po &
	@Test
	public void testUnaryOp() {
		CompletionModelBuilder modelBuilder = CompletionModelBuilder.modelBuilder();
		modelBuilder.withContent("fun po_loc : MemoryEvent->MemoryEvent {")
				.withCompletionLine(" ^po & ")
				.withContent("}");
		TextDocumentIdentifier textDocument = new TextDocumentIdentifier();
		CompletionContext completionContext = new CompletionContext(CompletionTriggerKind.TriggerCharacter, "&");
		Position position =
				new Position(modelBuilder.getCompletionLineNumber(), modelBuilder.getCompletionCharacterNumber()); // Line and character position where completion is triggered
		CompletionParams completionParams = new CompletionParams(textDocument, position, completionContext);

		var parser = CodeUtils.buildAlloyParser(modelBuilder.build());
		CompletionContextExtractorVisitor visitor = new CompletionContextExtractorVisitor(completionParams);
		var context = visitor.visit(parser.alloyModule());
		assertNotNull(context);
		assertThat(context.completionTerm().getText(), is("^po"));
		assertThat(context.completionOperator().getText(), is("&"));
	}
}