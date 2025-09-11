package alloy.language.server.visitors;

import alloy.language.server.alloyBaseVisitor;
import alloy.language.server.alloyParser;
import org.antlr.v4.runtime.ParserRuleContext;
import org.eclipse.lsp4j.CompletionParams;
import org.eclipse.lsp4j.Position;
import org.eclipse.lsp4j.Range;

public class IncompleteBlockRangeExtractorVisitor extends alloyBaseVisitor<Range> {
	private String alloyText;
	private Position position;

	public IncompleteBlockRangeExtractorVisitor(String alloyText, Position position) {
		this.alloyText = alloyText;
		this.position = position;
	}

	protected boolean isCompletionTriggeringLine(ParserRuleContext ctx) {
		return position.getLine() == ctx.getStop().getLine() - 1;
	}

	private alloyParser.BlockContext findBlockContext(ParserRuleContext ctx) {
		while (ctx != null && !(ctx instanceof alloyParser.BlockContext)) {
			ctx = ctx.getParent();
		}
		return (alloyParser.BlockContext) ctx;
	}

	@Override
	public Range visitExpr(alloyParser.ExprContext ctx) {
		if (isCompletionTriggeringLine(ctx)) {
			Position start = new Position(position.getLine() + 1,
			                              position.getCharacter());
			alloyParser.BlockContext blockContext = findBlockContext(ctx);
			if (blockContext != null) {
				var stop = blockContext.getStop();
				if (stop.getText().equals("}")) {
					Position end = new Position(stop.getLine() - 1, -1);
					return new Range(start, end);
				} else {
					Position end = new Position(stop.getLine(), -1);
					return new Range(start, end);
				}
			} else {
				// If no block context is found, return a range that includes the current position
				Position end = new Position(start.getLine(), -1);
				return new Range(start, end);
			}
		}
		return super.visitExpr(ctx);
	}

	@Override
	protected Range defaultResult() {
		return null;
	}

	@Override
	protected Range aggregateResult(Range aggregate, Range nextResult) {
		if (nextResult == null) {
			return aggregate;
		}
		return super.aggregateResult(aggregate, nextResult);
	}
}
