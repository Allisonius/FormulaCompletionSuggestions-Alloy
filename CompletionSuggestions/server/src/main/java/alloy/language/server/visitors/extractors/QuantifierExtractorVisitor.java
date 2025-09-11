package alloy.language.server.visitors.extractors;

import alloy.language.server.alloyParser;
import alloy.language.server.utils.AlloyExpressionParsingUtils;
import alloy.language.server.utils.CodeUtils;
import org.eclipse.lsp4j.CompletionParams;

import java.util.Map;

public class QuantifierExtractorVisitor extends AbstractExtractorVisitors {
	public QuantifierExtractorVisitor(String alloyText, CompletionParams completionParams) {
		super(alloyText, completionParams);
	}

	public QuantifierExtractorVisitor(String alloyText,
	                                  CompletionParams completionParams,
	                                  Map<String, alloyParser.ExprContext> existingDeclarations) {
		super(alloyText, completionParams, existingDeclarations);
	}

	@Override
	public Map<String, alloyParser.ExprContext> visitExpr(alloyParser.ExprContext ctx) {
		if(isCompletionTriggeringLine(ctx)) {
			if (ctx.quant() != null) {
				return AlloyExpressionParsingUtils.getQuantifierMap(ctx, existingDeclarations);
			}
			else if (ctx.implicationOp() != null) {
				return AlloyExpressionParsingUtils.getQuantifierMap(ctx.expr(0), existingDeclarations);
			}
			else if (ctx.compareOp() != null) {
				return AlloyExpressionParsingUtils.getQuantifierMap(ctx.expr(0), existingDeclarations);
			} else if (ctx.binOp() != null && CodeUtils.LOGICAL_OPERATORS.contains(ctx.binOp().getText())){
				return super.visitExpr(ctx);
			}
		}
		return super.visitExpr(ctx);
	}
}
