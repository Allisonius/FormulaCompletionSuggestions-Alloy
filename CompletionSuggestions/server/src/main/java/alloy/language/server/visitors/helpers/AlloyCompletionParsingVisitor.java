package alloy.language.server.visitors.helpers;

import alloy.language.server.alloyBaseVisitor;
import alloy.language.server.alloyParser;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ParseTree;
import org.eclipse.lsp4j.CompletionParams;
import org.eclipse.lsp4j.Position;


public class AlloyCompletionParsingVisitor extends alloyBaseVisitor<Position> {
	private final CompletionParams completionParams;

	public AlloyCompletionParsingVisitor(CompletionParams completionParams) {
		this.completionParams = completionParams;
	}

	protected boolean isCompletionTriggeringLine(ParserRuleContext ctx) {
		return completionParams.getPosition().getLine() == ctx.getStop().getLine() - 1;
	}

	protected alloyParser.BlockContext findParentBlock(ParserRuleContext ctx) {
		if (ctx.getParent() != null && ctx.getParent() instanceof alloyParser.BlockContext) {
			return (alloyParser.BlockContext) ctx.getParent();
		} else if (ctx.getParent() != null) {
			return findParentBlock( ctx.getParent());
		}
		return null;
	}

	@Override
	public Position visit(ParseTree tree) {
		if (tree instanceof ParserRuleContext && isCompletionTriggeringLine((ParserRuleContext) tree)) {
			return new Position(completionParams.getPosition().getLine(), 1000);
		}
		return super.visit(tree);
	}

	@Override
	public Position visitExpr(alloyParser.ExprContext ctx) {
		if (isCompletionTriggeringLine(ctx)) {
			alloyParser.BlockContext parentBlock = findParentBlock(ctx);
			if (parentBlock == null) {
				return super.visitExpr(ctx);
			}
			var endPosition = new Position(parentBlock.getStop().getLine(), parentBlock.getStop().getCharPositionInLine());
			return endPosition;
		}
		return super.visitExpr(ctx);
	}

	@Override
	protected Position aggregateResult(Position aggregate, Position nextResult) {
		if (aggregate.getLine() < nextResult.getLine()) {
			return nextResult;
		} else {
			return aggregate;
		}
	}

	@Override
	protected Position defaultResult() {
//		return new Position(completionParams.getPosition().getLine() + 1, 0);
		return null;
	}
}
