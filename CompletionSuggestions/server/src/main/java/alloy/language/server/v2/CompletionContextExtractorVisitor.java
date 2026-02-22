package alloy.language.server.v2;

import alloy.language.server.alloyBaseVisitor;
import alloy.language.server.alloyParser;
import alloy.language.server.utils.AlloyExpressionParsingUtils;
import alloy.language.server.utils.CodeUtils;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.ErrorNodeImpl;
import org.antlr.v4.runtime.tree.TerminalNodeImpl;
import org.eclipse.lsp4j.*;

import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Stream;

public class CompletionContextExtractorVisitor extends alloyBaseVisitor<IncompletionContext> {

	private final CompletionParams completionParams;

	public CompletionContextExtractorVisitor(CompletionParams completionParams) {
		this.completionParams = completionParams;
	}

	private boolean isCompletionTriggeringPosition(Position position, ParserRuleContext node) {
		// TODO: Check position matching logic more thoroughly
		boolean doesLineNumberMatches = position.getLine() + 1 == node.getStop().getLine() || position.getLine() + 1 == node.getStart().getLine(); // ANTLR lines are 1-based, LSP lines are 0-based
		int nodeEndCharPosition = node.getStop().getCharPositionInLine() + node.getText().length(); // 1 for dot . string length
		boolean isNodeClosestToCompletionTriggerColumnPosition =
				nodeEndCharPosition == position.getCharacter() // trigger at the exact position after the character
						|| nodeEndCharPosition + 1 == position.getCharacter() // trigger at the position after a space
				;
		// TODO: Trim the completion line

		return doesLineNumberMatches && isNodeClosestToCompletionTriggerColumnPosition;
	}

	private boolean isCompletionTriggeringPosition(Position position, TerminalNodeImpl node) {
		// TODO: Check position matching logic more thoroughly
		boolean doesLineNumberMatches = position.getLine() + 1 == node.getSymbol().getLine(); // ANTLR lines are 1-based, LSP lines are 0-based
		int nodeEndCharPosition = node.getSymbol().getCharPositionInLine() + node.getText().length(); // 1 for dot . string length
		boolean isNodeClosestToCompletionTriggerColumnPosition =
				nodeEndCharPosition == position.getCharacter() // trigger at the exact position after the character
						|| nodeEndCharPosition + 1 == position.getCharacter() // trigger at the position after a space
				;
		// TODO: Trim the completion line

		return doesLineNumberMatches && isNodeClosestToCompletionTriggerColumnPosition;
	}

	private boolean isCompletionTriggeringLine(Position position, ParserRuleContext node) {
		boolean doesLineNumberMatches = position.getLine() + 1 == node.getStop().getLine() || position.getLine() + 1 == node.getStart().getLine(); // ANTLR lines are 1-based, LSP lines are 0-based
		return doesLineNumberMatches;
	}

	private alloyParser.ExprContext findCompletionTermExpression(ParserRuleContext ctx) {
		alloyParser.ExprContext parent = (alloyParser.ExprContext) ctx.getParent();
		int ctxAsChildIndex = parent.children.indexOf(ctx);
		alloyParser.ExprContext rightMostSiblingBefore = null;
		for (var childExpr : parent.expr()) {
			if (parent.children.indexOf(childExpr) < ctxAsChildIndex) {
				rightMostSiblingBefore = childExpr;
			}
		}
		return AlloyExpressionParsingUtils.findCompletionTermExpression(rightMostSiblingBefore);
	}

	private alloyParser.ExprContext findCompletionTermExpression(TerminalNodeImpl ctx) {
		alloyParser.ExprContext parent = (alloyParser.ExprContext) ctx.getParent();
		int ctxAsChildIndex = parent.children.indexOf(ctx);
		alloyParser.ExprContext rightMostSiblingBefore = null;
		for (var childExpr : parent.expr()) {
			if (parent.children.indexOf(childExpr) < ctxAsChildIndex) {
				rightMostSiblingBefore = childExpr;
			}
		}
		return AlloyExpressionParsingUtils.findCompletionTermExpression(rightMostSiblingBefore);
	}

	@Override
	public IncompletionContext visitDotOp(alloyParser.DotOpContext ctx) {
		if (isCompletionTriggeringPosition(completionParams.getPosition(), ctx)) {
			alloyParser.ExprContext completionTerm = findCompletionTermExpression(ctx);
			return new IncompletionContext(completionTerm, ctx);
		}
		return super.visitDotOp(ctx);
	}

	@Override
	public IncompletionContext visitErrorNode(ErrorNode node) {
		if (isCompletionTriggeringPosition(completionParams.getPosition(), (ErrorNodeImpl) node)) {
			alloyParser.ExprContext completionTerm = findCompletionTermExpression((TerminalNodeImpl) node);
			return new IncompletionContext(completionTerm, (ErrorNodeImpl) node);
		}
		return super.visitErrorNode(node);
	}

//	@Override
//	public IncompletionContext visitTerminal(TerminalNode node) {
//		if (isCompletionTriggeringPosition(completionParams.getPosition(), (TerminalNodeImpl) node)) {
//			alloyParser.ExprContext completionTerm = findCompletionTermExpression((ParserRuleContext) node.getParent());
//			return new IncompletionContext(completionTerm, (ParserRuleContext) node.getParent());
//		}
//		return super.visitTerminal(node);
//	}

	@Override
	public IncompletionContext visitBinOp(alloyParser.BinOpContext ctx) {
		if (isCompletionTriggeringPosition(completionParams.getPosition(), ctx)) {
			alloyParser.ExprContext completionTerm = findCompletionTermExpression(ctx);
			return new IncompletionContext(completionTerm, ctx);
		}
		return super.visitBinOp(ctx);
	}

	@Override
	public IncompletionContext visitCompareOp(alloyParser.CompareOpContext ctx) {
		if (isCompletionTriggeringPosition(completionParams.getPosition(), ctx)) {
			alloyParser.ExprContext completionTerm = findCompletionTermExpression(ctx);
			return new IncompletionContext(completionTerm, ctx);
		}
		return super.visitCompareOp(ctx);
	}

	@Override
	public IncompletionContext visitSetOp(alloyParser.SetOpContext ctx) {
		if (isCompletionTriggeringPosition(completionParams.getPosition(), ctx)) {
			alloyParser.ExprContext completionTerm = findCompletionTermExpression(ctx);
			return new IncompletionContext(completionTerm, ctx);
		}
		return super.visitSetOp(ctx);
	}

	@Override
	public IncompletionContext visitArrowOp(alloyParser.ArrowOpContext ctx) {
		TerminalNodeImpl arrowNode = ctx.children.stream()
				.filter(child -> child instanceof TerminalNodeImpl)
				.map(child -> (TerminalNodeImpl) child)
				.filter(terminalNode -> terminalNode.getText().equals("->"))
				.findFirst()
				.orElse(null);
		if (arrowNode == null) {
			return super.visitArrowOp(ctx);
		}
		if (isCompletionTriggeringPosition(completionParams.getPosition(), arrowNode)) {
			alloyParser.ExprContext completionTerm = findCompletionTermExpression(ctx);
			return new IncompletionContext(completionTerm, ctx);
		}
		return super.visitArrowOp(ctx);
	}

	@Override
	public IncompletionContext visitSigExt(alloyParser.SigExtContext ctx) {
		TerminalNodeImpl extendsNode = ctx.children.stream()
				.filter(child -> child instanceof TerminalNodeImpl)
				.map(child -> (TerminalNodeImpl) child)
				.filter(terminalNode -> terminalNode.getText().equals("extends") || terminalNode.getText().equals("in"))
				.findFirst()
				.orElse(null);
		if (isCompletionTriggeringPosition(completionParams.getPosition(), extendsNode)) {
			return new IncompletionContext(null, extendsNode);
		}
		return super.visitSigExt(ctx);
	}

	@Override
	protected IncompletionContext aggregateResult(IncompletionContext aggregate, IncompletionContext nextResult) {
		// return the last non-null result
		return nextResult != null ? nextResult : aggregate;
	}
}
