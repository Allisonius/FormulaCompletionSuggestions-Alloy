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

public class DotVisitor extends AbstractCompletionVisitors {

	public DotVisitor(String alloyText, CompletionParams completionParams, AlloyEvaluation alloyEvaluation) {
		super(alloyText, completionParams, alloyEvaluation);
	}

	public DotVisitor(String alloyText,
	                  CompletionParams completionParams,
	                  AlloyEvaluation alloyEvaluation,
	                  Map<String, alloyParser.ExprContext> quantifiers) {
		super(alloyText, completionParams, alloyEvaluation, quantifiers);
	}

	@Override
	public List<CompletionItem> visitExpr(alloyParser.ExprContext ctx) {
		if (isCompletionTriggeringLine(ctx) && getInvalidTokenText(ctx).equals(".")) {
			if (shouldVisitDeeper(ctx)) {
				return super.visitExpr(ctx);
			}
//			if (ctx.expr().size() > 1 && !ctx.expr(ctx.expr().size() - 1).getText().isEmpty()) {
//				return super.visitExpr(ctx);
//			}
			// TODO 12/22/24: Dot operator may have type scoping, e.g. "Person.(Class.<>)"
//			alloyParser.ExprContext previousChild = ctx.qualName() != null ? ctx : ctx.expr(0);
			var declaredVariables = AlloyExpressionParsingUtils.findDeclaredVariables(ctx, quantifiers);
			var mergedQuantifiers = new ConcurrentHashMap<>(quantifiers);
			mergedQuantifiers.putAll(declaredVariables);

			alloyParser.ExprContext previousChild = ctx;
			String qualName = AlloyExpressionParsingUtils.findQualifierName(previousChild, mergedQuantifiers);
			if (qualName == null || qualName.isEmpty()) {
				return super.visitExpr(ctx);
			}

			List<EvaluationResult> evaluationResults = alloyEvaluation.evalDot(qualName, mergedQuantifiers);
			return evaluationResults.stream()
			                        .map(EvaluationResult::toCompletionItemOfVariableKind)
			                        .collect(Collectors.toList());
		}
		return super.visitExpr(ctx);
	}
}
