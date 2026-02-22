package alloy.language.server.visitors.completions;

import alloy.language.server.alloyParser;
import alloy.language.server.utils.AlloyEvaluation;
import alloy.language.server.utils.AlloyExpressionParsingUtils;
import alloy.language.server.utils.data.EvaluationResult;
import org.eclipse.lsp4j.CompletionItem;
import org.eclipse.lsp4j.CompletionParams;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

public class QuantifierCompletionVisitor extends AbstractCompletionVisitors {
	public QuantifierCompletionVisitor(String alloyText, CompletionParams completionParams, AlloyEvaluation alloyEvaluation) {
		super(alloyText, completionParams, alloyEvaluation);
	}

	public QuantifierCompletionVisitor(String alloyText,
	                                   CompletionParams completionParams,
	                                   AlloyEvaluation alloyEvaluation,
	                                   Map<String, alloyParser.ExprContext> quantifiers) {
		super(alloyText, completionParams, alloyEvaluation, quantifiers);
	}

	@Override
	public List<CompletionItem> visitExpr(alloyParser.ExprContext ctx) {
		if (isCompletionTriggeringLine(ctx) && ctx.getChild(0) instanceof alloyParser.QuantContext) {
			var declarations = ctx.decl();
			Map<String, alloyParser.ExprContext> currentQuantifiers = new ConcurrentHashMap<>(quantifiers);
			List<EvaluationResult> evaluationResults = new ArrayList<>();
			for (var decl : declarations) {
				if (decl.getStop().getText().equals(".")) {
					// TODO: 8/23/24 Implement the logic for the dot operator
					var expr = decl.expr();
					var previousChild = expr.expr(0);
					String qualName = AlloyExpressionParsingUtils.findQualifierName(previousChild, currentQuantifiers);
					var completions = alloyEvaluation.evalDot(qualName, currentQuantifiers);
					evaluationResults.addAll(completions);
				}
				else {
					var names = decl.name();
					for (var name : names) {
						currentQuantifiers.put(name.getText(),
						                AlloyExpressionParsingUtils.parseExpWithQuantifier(decl.expr(), currentQuantifiers));
					}
				}
			}
			return evaluationResults.stream()
			                        .map(EvaluationResult::toCompletionItemOfVariableKind)
			                        .collect(Collectors.toList());
		}
		return super.visitExpr(ctx);
	}
}
