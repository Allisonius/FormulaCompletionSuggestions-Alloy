package alloy.language.server.visitors;

import alloy.language.server.alloyBaseVisitor;
import alloy.language.server.alloyParser;
import alloy.language.server.utils.TextEditor;
import org.antlr.v4.runtime.ParserRuleContext;
import org.eclipse.lsp4j.CompletionParams;
import org.eclipse.lsp4j.Position;

public class BaselineExpressionExtractorVisitor extends alloyBaseVisitor<String> {
	protected String alloyText;
	protected Position position;

	public BaselineExpressionExtractorVisitor(String alloyText, Position position) {
		this.alloyText = alloyText;
		this.position = position;
	}

	protected boolean isCompletionTriggeringLine(ParserRuleContext ctx) {
		return position.getLine() == ctx.getStop().getLine() - 1;
	}

	public String getInvalidTokenText(ParserRuleContext ctx) {
		return ctx.exception instanceof org.antlr.v4.runtime.NoViableAltException ?
				((org.antlr.v4.runtime.NoViableAltException) ctx.exception).getStartToken().getText() :
				ctx.getStop().getText();
	}

	@Override
	public String visitErrorNode(org.antlr.v4.runtime.tree.ErrorNode node) {
		if (!(node.getParent() instanceof alloyParser.ExprContext)) {
			return null;
		}
		alloyParser.ExprContext parent = (alloyParser.ExprContext) node.getParent();
		while(parent != null && parent.binOp() == null) {
			var parentOfParent = parent.getParent();
			if (parentOfParent instanceof alloyParser.ExprContext) {
				parent = (alloyParser.ExprContext) parentOfParent;
			} else {
				return null; // No valid parent found
			}
		}
		var binOp = parent.binOp();
		var start = new Position(binOp.getStart().getLine(), binOp.getStart().getCharPositionInLine());
		TextEditor editor = new TextEditor(alloyText);
		String baselineText = editor.getLineUntilCharacterPosition(start.getLine(), start.getCharacter());
		return baselineText;
	}

	@Override
	protected String aggregateResult(String aggregate, String nextResult) {
		if (nextResult == null) {
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
