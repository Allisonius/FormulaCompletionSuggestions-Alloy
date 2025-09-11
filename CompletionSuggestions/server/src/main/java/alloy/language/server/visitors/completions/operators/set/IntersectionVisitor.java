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

public class IntersectionVisitor extends AbstractCompletionVisitors {
	public IntersectionVisitor(String alloyText, CompletionParams completionParams, AlloyEvaluation alloyEvaluation) {
		super(alloyText, completionParams, alloyEvaluation);
	}

	public IntersectionVisitor(String alloyText,
	                           CompletionParams completionParams,
	                           AlloyEvaluation alloyEvaluation,
	                           Map<String, alloyParser.ExprContext> quantifiers) {
		super(alloyText, completionParams, alloyEvaluation, quantifiers);
	}

	@Override
	public List<CompletionItem> visitExpr(alloyParser.ExprContext ctx) {
		if (isCompletionTriggeringLine(ctx) && ctx.getStop().getText().equals("&")) {
			alloyParser.ExprContext previousChild = (alloyParser.ExprContext) ctx.getChild(0);
			String qualName = AlloyExpressionParsingUtils.findQualifierName(previousChild);

			var declaredVariables = AlloyExpressionParsingUtils.findDeclaredVariables(ctx, quantifiers);
			var mergedQuantifiers = new ConcurrentHashMap<>(quantifiers);
			mergedQuantifiers.putAll(declaredVariables);

			List<EvaluationResult> evaluationResults = alloyEvaluation.evalIntersection(qualName, mergedQuantifiers);
			return evaluationResults.stream().map(EvaluationResult::toCompletionItemOfVariableKind).collect(Collectors.toList());
		}
		return super.visitExpr(ctx);
	}
}
