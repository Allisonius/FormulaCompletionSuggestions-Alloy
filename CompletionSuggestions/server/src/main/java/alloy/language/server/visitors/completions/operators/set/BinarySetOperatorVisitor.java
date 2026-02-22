package alloy.language.server.visitors.completions.operators.set;

import alloy.language.server.alloyParser;
import alloy.language.server.utils.AlloyEvaluation;
import alloy.language.server.utils.AlloyExpressionParsingUtils;
import alloy.language.server.utils.AlloyInstanceUtils;
import alloy.language.server.utils.data.EvaluationResult;
import alloy.language.server.v2.IncompletionContext;
import alloy.language.server.visitors.completions.AbstractCompletionVisitors;
import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.TerminalNodeImpl;
import org.eclipse.lsp4j.CompletionItem;
import org.eclipse.lsp4j.CompletionParams;

import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

public class BinarySetOperatorVisitor extends AbstractCompletionVisitors {
	private final Set<String> setOperators = Set.of("+", "&", "in", "=");

	public BinarySetOperatorVisitor(
			String alloyText, CompletionParams completionParams, AlloyEvaluation alloyEvaluation) {
		super(alloyText, completionParams, alloyEvaluation);
	}

	public BinarySetOperatorVisitor(String alloyText,
	                                CompletionParams completionParams,
	                                AlloyEvaluation alloyEvaluation,
	                                Map<String, alloyParser.ExprContext> quantifiers) {
		super(alloyText, completionParams, alloyEvaluation, quantifiers);
	}

//	@Override
//	public List<CompletionItem> visitExpr(alloyParser.ExprContext ctx) {

	/// /		if (isCompletionTriggeringLine(ctx) && setOperators.contains(ctx.getStop().getText())) {
//		if (isCompletionTriggeringLine(ctx) && setOperators.contains(getInvalidTokenText(ctx))) {
//			if (shouldVisitDeeper(ctx)) {
//				return super.visitExpr(ctx);
//			}
//			if (ctx.expr().size() > 1 && ctx.dotOp() == null && ctx.arrowOp() == null && !ctx.expr(ctx.expr().size() - 1).getText().isEmpty()) {
//				return super.visitExpr(ctx);
//			}
//			if (ctx.qualName() == null && ctx.expr().isEmpty()) {
//				return super.visitExpr(ctx);
//			}
//
//			alloyParser.ExprContext previousChild = ctx.expr(0);
//			var deepestExpression = AlloyExpressionParsingUtils.findDeepestExpression(previousChild);
//			var declaredVariables = AlloyExpressionParsingUtils.findDeclaredVariables(deepestExpression, quantifiers);
//			var mergedQuantifiers = new ConcurrentHashMap<>(quantifiers);
//			mergedQuantifiers.putAll(declaredVariables);
//
//			String operator = getInvalidTokenText(ctx);
//			String qualName = AlloyExpressionParsingUtils.findQualifierName(previousChild, mergedQuantifiers);
//			List<EvaluationResult> evaluationResults = alloyEvaluation.evalBinarySetOpByMatchingArity(qualName, operator, mergedQuantifiers);
//			return evaluationResults.stream().map(EvaluationResult::toCompletionItemOfVariableKind).collect(Collectors.toList());
//		}
//		return super.visitExpr(ctx);
//	}
	@Override
	public List<CompletionItem> visitSetOp(alloyParser.SetOpContext ctx) {
		if (setOperators.contains(ctx.getText()) && isCompletionTriggeringPosition(completionParams.getPosition(), ctx)) {
			alloyParser.ExprContext completionTerm = findCompletionTermExpression(ctx);
			String operator = ctx.getText();
			return processCompletion(completionTerm, operator);
		}
		return super.visitSetOp(ctx);
	}

	@Override
	public List<CompletionItem> visitCompareOp(alloyParser.CompareOpContext ctx) {
		if (setOperators.contains(ctx.getText()) && isCompletionTriggeringPosition(completionParams.getPosition(), ctx)) {
			alloyParser.ExprContext completionTerm = findCompletionTermExpression(ctx);
			String operator = ctx.getText();
			return processCompletion(completionTerm, operator);
		}
		return super.visitCompareOp(ctx);
	}

	@Override
	public List<CompletionItem> visitErrorNode(ErrorNode node) {
		if (setOperators.contains(node.getText()) && isCompletionTriggeringPosition(completionParams.getPosition(), (TerminalNodeImpl) node)) {
			alloyParser.ExprContext completionTerm = findCompletionTermExpression((org.antlr.v4.runtime.tree.TerminalNodeImpl) node);
			String operator = node.getText();
			if (setOperators.contains(operator)) {
				return processCompletion(completionTerm, operator);
			}
		}
		return super.visitErrorNode(node);
	}

	private List<CompletionItem> processCompletion(alloyParser.ExprContext completionTerm, String operator) {
		var declaredVariables = AlloyExpressionParsingUtils.findDeclaredVariables(completionTerm, quantifiers);
		var mergedQuantifiers = new ConcurrentHashMap<>(quantifiers);
		mergedQuantifiers.putAll(declaredVariables);

		String qualName = AlloyExpressionParsingUtils.findQualifierName(completionTerm, mergedQuantifiers);
		List<EvaluationResult> evaluationResults = alloyEvaluation.evalBinarySetOpByMatchingArity(qualName, operator, mergedQuantifiers);
		return evaluationResults.stream().map(EvaluationResult::toCompletionItemOfVariableKind).collect(Collectors.toList());
	}
}
