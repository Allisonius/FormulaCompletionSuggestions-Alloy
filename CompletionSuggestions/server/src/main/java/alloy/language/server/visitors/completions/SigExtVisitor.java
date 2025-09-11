package alloy.language.server.visitors.completions;

import alloy.language.server.alloyParser;
import alloy.language.server.utils.AlloyEvaluation;
import org.eclipse.lsp4j.CompletionItem;
import org.eclipse.lsp4j.CompletionItemKind;
import org.eclipse.lsp4j.CompletionParams;

import java.util.List;
import java.util.Map;
import java.util.Set;

public class SigExtVisitor extends AbstractCompletionVisitors {

	private static final Set<String> extOps = Set.of("extends", "in");

	public SigExtVisitor(String alloyText, CompletionParams completionParams, AlloyEvaluation alloyEvaluation) {
		super(alloyText, completionParams, alloyEvaluation);
	}

	public SigExtVisitor(String alloyText,
	                     CompletionParams completionParams,
	                     AlloyEvaluation alloyEvaluation,
	                     Map<String, alloyParser.ExprContext> quantifiers) {
		super(alloyText, completionParams, alloyEvaluation, quantifiers);
	}

	@Override
	public List<CompletionItem> visitSigExt(alloyParser.SigExtContext ctx) {
		if (completionParams.getPosition()
		                    .getLine() == ctx.getStart()
		                                     .getLine() - 1) {
			var allSigs = alloyEvaluation.getAllSigsAsSuggestions();
			return allSigs.stream()
			              .map(sig -> {
				              var completionItem = new CompletionItem();
				              completionItem.setLabel(sig.getLabel());
				              completionItem.setKind(CompletionItemKind.Class);
				              completionItem.setSortText(String.valueOf(sig.getDegree().ordinal()));
				              completionItem.setDocumentation("Documentation: Completion Signatures");
				              completionItem.setDetail("Detail: Signature");
				              return completionItem;
			              })
			              .collect(java.util.stream.Collectors.toList());
		}
		return super.visitSigExt(ctx);
	}
}
