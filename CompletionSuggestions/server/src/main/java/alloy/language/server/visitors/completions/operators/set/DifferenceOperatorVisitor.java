package alloy.language.server.visitors.completions.operators.set;

import alloy.language.server.alloyParser;
import alloy.language.server.utils.AlloyEvaluation;
import alloy.language.server.utils.AlloyExpressionParsingUtils;
import alloy.language.server.utils.data.EvaluationResult;
import alloy.language.server.visitors.completions.AbstractCompletionVisitors;
import org.eclipse.lsp4j.CompletionItem;
import org.eclipse.lsp4j.CompletionParams;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

public class DifferenceOperatorVisitor extends AbstractCompletionVisitors {
	public DifferenceOperatorVisitor(String alloyText,
	                                 CompletionParams completionParams,
	                                 AlloyEvaluation alloyEvaluation) {
		super(alloyText, completionParams, alloyEvaluation);
	}

	public DifferenceOperatorVisitor(String alloyText,
	                                 CompletionParams completionParams,
	                                 AlloyEvaluation alloyEvaluation,
	                                 Map<String, alloyParser.ExprContext> quantifiers) {
		super(alloyText, completionParams, alloyEvaluation, quantifiers);
	}

	@Override
	public List<CompletionItem> visitExpr(alloyParser.ExprContext ctx) {
		if (isCompletionTriggeringLine(ctx) && getInvalidTokenText(ctx).equals("-")
			//		ctx.getStop().getText().equals("-") ||
			//		                                        (ctx.exception instanceof NoViableAltException &&
			//		                                         ((NoViableAltException) ctx.exception).getStartToken()
			//		                                                                               .getText()
			//		                                                                               .equals("-"))
		) {
			if (shouldVisitDeeper(ctx)) {
				return super.visitExpr(ctx);
			}
			alloyParser.ExprContext previousChild = ctx;
			if (ctx.const_() != null) {
				var parent = ctx.getParent();
				int thisChildIndex = 0;
				for (int i = 0; i < parent.getChildCount(); i++) {
					if (parent.getChild(i) == ctx) {
						thisChildIndex = i;
						break;
					}
				}
				previousChild = (alloyParser.ExprContext) parent.getChild(thisChildIndex - 1);
			} else if (ctx.getChild(0) instanceof alloyParser.ExprContext) {
				previousChild = (alloyParser.ExprContext) ctx.getChild(0);
			} else if (ctx.getChild(ctx.getChildCount() - 2) instanceof alloyParser.BlockOrBarContext) {
				var blockOrBarContext = (alloyParser.BlockOrBarContext) ctx.getChild(ctx.getChildCount() - 2);
				previousChild = blockOrBarContext.expr();
			}

			var declaredVariables = AlloyExpressionParsingUtils.findDeclaredVariables(ctx, quantifiers);
			var mergedQuantifiers = new ConcurrentHashMap<>(quantifiers);
			mergedQuantifiers.putAll(declaredVariables);

			String qualName = AlloyExpressionParsingUtils.findQualifierName(previousChild, mergedQuantifiers);
			List<EvaluationResult> evaluationResults =
					alloyEvaluation.evalBinarySetOpByMatchingArity(qualName, "-", mergedQuantifiers);
			return evaluationResults.stream()
			                        .map(EvaluationResult::toCompletionItemOfVariableKind)
			                        .collect(Collectors.toList());
		}
		return super.visitExpr(ctx);
	}
}
