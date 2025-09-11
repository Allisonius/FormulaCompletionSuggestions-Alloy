package alloy.language.server.visitors.completions.operators;

import alloy.language.server.alloyParser;
import alloy.language.server.utils.AlloyEvaluation;
import alloy.language.server.utils.AlloyExpressionParsingUtils;
import alloy.language.server.utils.data.EvaluationResult;
import alloy.language.server.visitors.completions.AbstractCompletionVisitors;
import org.antlr.v4.runtime.NoViableAltException;
import org.eclipse.lsp4j.CompletionItem;
import org.eclipse.lsp4j.CompletionParams;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

public class ExceptionExpVisitor extends AbstractCompletionVisitors {
	public ExceptionExpVisitor(String alloyText,
	                           CompletionParams completionParams,
	                           AlloyEvaluation alloyEvaluation,
	                           Map<String, alloyParser.ExprContext> quantifiers) {
		super(alloyText, completionParams, alloyEvaluation, quantifiers);
	}

	@Override
	public List<CompletionItem> visitExpr(alloyParser.ExprContext ctx) {
		if (isCompletionTriggeringLine(ctx) && ctx.exception instanceof NoViableAltException &&
		    !ctx.getText().isEmpty()) {
			String qualName = "";
			if(ctx.qualName() != null) {
				qualName = ctx.qualName().getText();
			} else {
				var declaredVariables = AlloyExpressionParsingUtils.findDeclaredVariables(ctx, quantifiers);
				var mergedQuantifiers = new ConcurrentHashMap<>(quantifiers);
				mergedQuantifiers.putAll(declaredVariables);

				alloyParser.ExprContext completionTerm = ctx.expr(ctx.expr().size() - 1);
				qualName = AlloyExpressionParsingUtils.findQualifierName(completionTerm, mergedQuantifiers);
			}

			var declaredVariables = AlloyExpressionParsingUtils.findDeclaredVariables(ctx, quantifiers);
			var mergedQuantifiers = new ConcurrentHashMap<>(quantifiers);
			mergedQuantifiers.putAll(declaredVariables);

			List<EvaluationResult> evaluationResults = alloyEvaluation.evalDot(qualName, mergedQuantifiers);
			return evaluationResults.stream()
			                        .map(EvaluationResult::toCompletionItemOfVariableKind)
			                        .collect(Collectors.toList());
		}
		return super.visitExpr(ctx);
	}
}
