package alloy.language.server.visitors.completions.operators.binary;

import alloy.language.server.alloyParser;
import alloy.language.server.utils.AlloyEvaluation;
import alloy.language.server.utils.AlloyExpressionParsingUtils;
import alloy.language.server.utils.data.EvaluationResult;
import alloy.language.server.visitors.completions.AbstractCompletionVisitors;
import org.eclipse.lsp4j.CompletionItem;
import org.eclipse.lsp4j.CompletionParams;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class InFormulaVisitor extends AbstractCompletionVisitors {
    public InFormulaVisitor(String alloyText, CompletionParams completionParams, AlloyEvaluation alloyEvaluation) {
        super(alloyText, completionParams, alloyEvaluation);
    }

    public InFormulaVisitor(String alloyText,
                            CompletionParams completionParams,
                            AlloyEvaluation alloyEvaluation,
                            Map<String, alloyParser.ExprContext> quantifiers) {
        super(alloyText, completionParams, alloyEvaluation, quantifiers);
    }

    @Override
    public List<CompletionItem> visitExpr(alloyParser.ExprContext ctx) {
        if (isCompletionTriggeringLine(ctx) && ctx.getStop().getText().equals("in")) {
            if (ctx.expr().size() > 1 && !ctx.expr(ctx.expr().size() - 1).getText().isEmpty()) {
                return super.visitExpr(ctx);
            }
            if (ctx.expr().size() == 0) {
                return super.visitExpr(ctx);
            }
            alloyParser.ExprContext previousChild = ctx.expr(0);
            String qualName = AlloyExpressionParsingUtils.findQualifierName(previousChild, quantifiers);
            List<EvaluationResult> evaluationResults = alloyEvaluation.evalIn(qualName, quantifiers);
            return evaluationResults.stream().map(EvaluationResult::toCompletionItemOfVariableKind).collect(Collectors.toList());
        }
        return super.visitExpr(ctx);
    }
}
