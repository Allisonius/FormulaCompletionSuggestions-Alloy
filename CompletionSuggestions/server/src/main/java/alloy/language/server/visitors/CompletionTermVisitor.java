package alloy.language.server.visitors;

import alloy.language.server.alloyBaseVisitor;
import alloy.language.server.alloyParser;
import alloy.language.server.utils.AlloyExpressionParsingUtils;
import org.eclipse.lsp4j.Position;

public class CompletionTermVisitor extends alloyBaseVisitor<String> {
    protected String alloyText;
    protected Position position;

    public CompletionTermVisitor(String alloyText, Position position) {
        this.alloyText = alloyText;
        this.position = position;
    }

    protected boolean isCompletionTriggeringLine(org.antlr.v4.runtime.ParserRuleContext ctx) {
        return position.getLine() == ctx.getStop().getLine() - 1;
    }

    @Override
    public String visitErrorNode(org.antlr.v4.runtime.tree.ErrorNode node) {
        if (!(node.getParent() instanceof alloyParser.ExprContext)) {
            return null;
        }
        alloyParser.ExprContext parent = (alloyParser.ExprContext) node.getParent();
        return AlloyExpressionParsingUtils.findQualifierName(parent);
//        if (parent.expr().isEmpty()) {
//            return null;
//        }
//        return parent.expr().getLast().getText();
    }

    @Override
    public String visitExpr(alloyParser.ExprContext ctx) {
        if (ctx.exception != null) {
            if (ctx.children != null && !ctx.children.isEmpty()) {
                return AlloyExpressionParsingUtils.findQualifierName(ctx);
            }
            alloyParser.ExprContext parent = (alloyParser.ExprContext) ctx.getParent();
            return AlloyExpressionParsingUtils.findQualifierName(parent.expr(0));

        }
        return super.visitExpr(ctx);
    }

    @Override
    protected String aggregateResult(String aggregate, String nextResult) {
        if (aggregate != null) {
            return aggregate;
        } else {
            return nextResult;
        }
    }

    @Override
    protected String defaultResult() {
        return null;
    }

}
