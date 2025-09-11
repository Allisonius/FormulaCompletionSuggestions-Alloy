package alloy.language.server.visitors.completions.operators.set;

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
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

public class RelationalChainAfterBinaryOperatorVisitor extends AbstractCompletionVisitors {

	private final Set<String> suitableOperators = Set.of("in", "=", "&", "+");

	public RelationalChainAfterBinaryOperatorVisitor(String alloyText,
	                                                 CompletionParams completionParams,
	                                                 AlloyEvaluation alloyEvaluation,
	                                                 Map<String, alloyParser.ExprContext> quantifiers) {
		super(alloyText, completionParams, alloyEvaluation, quantifiers);
	}

	private alloyParser.ExprContext findLeftHandSideExpr(alloyParser.ExprContext ctx) {
		if (ctx.expr().isEmpty()) {
			return ctx;
		}
		if (ctx.compareOp() != null) {
			return ctx.expr(0);
		}
		if (ctx.unOp()!= null) {
			return ctx.expr(0);
		}
		if (ctx.setOp() != null) {
			return ctx.expr(0);
		}
		else if (ctx.binOp() != null && suitableOperators.contains(ctx.binOp().getText())) {
			return ctx.expr(0);
		}
		else if (ctx.getParent() != null && ctx.getParent() instanceof alloyParser.ExprContext) {
			return findLeftHandSideExpr((alloyParser.ExprContext) ctx.getParent());
		}
		return null;
	}

	@Override
	public List<CompletionItem> visitExpr(alloyParser.ExprContext ctx) {
		try {
			if (isCompletionTriggeringLine(ctx) && suitableOperators.contains(getInvalidTokenText(ctx))) {
//				if (ctx.expr().size() == 0) {
//					return List.of();
//				}
				if (shouldVisitDeeper(ctx)) {
					return super.visitExpr(ctx);
				}
				if (ctx.expr().size() > 1 && ctx.dotOp() == null && ctx.arrowOp() == null & !ctx.expr(ctx.expr().size() - 1).getText().isEmpty()) {
					return super.visitExpr(ctx);
				}

//				if (ctx.expr().size() > 1 && ctx.compareOp() != null && ctx.expr(1).children == null) {
//					// More than one binary operator, e.g. "A + B + "
//					return super.visitExpr(ctx);
//				}

				alloyParser.ExprContext previousChild = ctx.exception == null ? ctx.expr(0) : ctx;
				if (ctx.expr().isEmpty()){
					previousChild = ctx;
				}
				var leftHandSideExpr = ctx.exception == null ? findLeftHandSideExpr(previousChild) : previousChild;
				if (leftHandSideExpr == null) {
					return super.visitExpr(ctx);
				}

				var declaredVariables = AlloyExpressionParsingUtils.findDeclaredVariables(ctx, quantifiers);
				var mergedQuantifiers = new ConcurrentHashMap<>(quantifiers);
				mergedQuantifiers.putAll(declaredVariables);

				var leftHandSideQualifierName = AlloyExpressionParsingUtils.findQualifierName(leftHandSideExpr, mergedQuantifiers);
				var completionOperator = Objects.isNull(ctx.exception) || !(ctx.exception instanceof NoViableAltException) ? null : ((NoViableAltException) ctx.exception).getStartToken().getText();
				if ((completionOperator != null && ctx.getStop().getText().equals(completionOperator)) || ctx.getStop().getText().equals(".")) {
					String sourceExprQualName = AlloyExpressionParsingUtils.findQualifierName(previousChild, mergedQuantifiers);
					List<EvaluationResult> evaluationResults =
							alloyEvaluation.evalForwardRelationalChainFromSourceExprToDestinationExpr(sourceExprQualName,
							                                                                          leftHandSideQualifierName,
							                                                                          mergedQuantifiers);
					return evaluationResults.stream().map(EvaluationResult::toCompletionItemOfVariableKind).collect(Collectors.toList());
				}
				if (completionOperator != null && suitableOperators.contains(completionOperator)) {
					var operator = completionOperator;
					List<EvaluationResult> evaluationResults = alloyEvaluation.evalRelationalChainForDestinationExpr(leftHandSideQualifierName, operator, mergedQuantifiers);
					return evaluationResults.stream().map(EvaluationResult::toCompletionItemOfVariableKind).collect(Collectors.toList());
				} else if (suitableOperators.contains(ctx.getStop().getText())) {
					var operator = ctx.getStop().getText();
					List<EvaluationResult> evaluationResults = alloyEvaluation.evalRelationalChainForDestinationExpr(leftHandSideQualifierName, operator, mergedQuantifiers);
					return evaluationResults.stream().map(EvaluationResult::toCompletionItemOfVariableKind).collect(Collectors.toList());
				} else {
					return super.visitExpr(ctx);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return super.visitExpr(ctx);
	}
}
