package alloy.language.server.visitors.completions.operators.binary;

import alloy.language.server.alloyParser;
import alloy.language.server.utils.AlloyEvaluation;
import alloy.language.server.utils.AlloyExpressionParsingUtils;
import alloy.language.server.utils.CodeUtils;
import alloy.language.server.visitors.completions.AbstractCompletionVisitors;
import org.antlr.v4.runtime.tree.TerminalNodeImpl;
import org.eclipse.lsp4j.CompletionItem;
import org.eclipse.lsp4j.CompletionItemKind;
import org.eclipse.lsp4j.CompletionParams;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Stream;

public class ArrowExprVisitor extends AbstractCompletionVisitors {

	public ArrowExprVisitor(String alloyText, CompletionParams completionParams, AlloyEvaluation alloyEvaluation) {
		super(alloyText, completionParams, alloyEvaluation);
	}

	public ArrowExprVisitor(String alloyText,
	                        CompletionParams completionParams,
	                        AlloyEvaluation alloyEvaluation,
	                        Map<String, alloyParser.ExprContext> quantifiers) {
		super(alloyText, completionParams, alloyEvaluation, quantifiers);
	}

	@Override
	public List<CompletionItem> visitArrowOp(alloyParser.ArrowOpContext ctx) {
		TerminalNodeImpl arrowNode = ctx.children.stream()
				.filter(child -> child instanceof TerminalNodeImpl)
				.map(child -> (TerminalNodeImpl) child)
				.filter(terminalNode -> terminalNode.getText().equals("->"))
				.findFirst()
				.orElse(null);
		if (arrowNode == null) {
			return super.visitArrowOp(ctx);
		}
		if (isCompletionTriggeringPosition(completionParams.getPosition(), arrowNode)) {
			alloyParser.ExprContext completionTerm = findCompletionTermExpression(ctx);
			var declaredVariables = AlloyExpressionParsingUtils.findDeclaredVariables(completionTerm, quantifiers);
			var mergedQuantifiers = new ConcurrentHashMap<>(quantifiers);
			mergedQuantifiers.putAll(declaredVariables);

			var allSigs = alloyEvaluation.getAllSigsAsSuggestions();
			var allQuantifiers = CodeUtils.suggestionListFromQuantifiers(mergedQuantifiers, alloyEvaluation.getWorld());
			return Stream.concat(allSigs.stream(), allQuantifiers.stream()).map(sig -> {
				var completionItem = new CompletionItem();
				completionItem.setLabel(sig.getLabel());
				completionItem.setKind(CompletionItemKind.Class);
				completionItem.setDocumentation("Documentation: Completion Signatures");
				completionItem.setDetail("Detail: Signature");
				completionItem.setSortText(String.valueOf(sig.getDegree().ordinal()));
				return completionItem;
			}).collect(java.util.stream.Collectors.toList());
		}
		return super.visitArrowOp(ctx);
	}

//	@Override
//	public List<CompletionItem> visitExpr(alloyParser.ExprContext ctx) {
//		if (isCompletionTriggeringLine(ctx) && getInvalidTokenText(ctx).equals("->")) {
//			if (shouldVisitDeeper(ctx)) {
//				return super.visitExpr(ctx);
//			}
//			var allSigs = alloyEvaluation.getAllSigsAsSuggestions();
//			var declaredVariables = AlloyExpressionParsingUtils.findDeclaredVariables(ctx, quantifiers);
//			var mergedQuantifiers = new ConcurrentHashMap<>(quantifiers);
//			mergedQuantifiers.putAll(declaredVariables);
//			var allQuantifiers = CodeUtils.suggestionListFromQuantifiers(mergedQuantifiers, alloyEvaluation.getWorld());
//			return Stream.concat(allSigs.stream(), allQuantifiers.stream()).map(sig -> {
//				var completionItem = new CompletionItem();
//				completionItem.setLabel(sig.getLabel());
//				completionItem.setKind(CompletionItemKind.Class);
//				completionItem.setDocumentation("Documentation: Completion Signatures");
//				completionItem.setDetail("Detail: Signature");
//				completionItem.setSortText(String.valueOf(sig.getDegree().ordinal()));
//				return completionItem;
//			}).collect(java.util.stream.Collectors.toList());
//		}
//		return super.visitExpr(ctx);
//	}
}
