package alloy.language.server.visitors.completions;

import alloy.language.server.alloyBaseVisitor;
import alloy.language.server.alloyParser;
import alloy.language.server.utils.AlloyEvaluation;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ErrorNodeImpl;
import org.antlr.v4.runtime.tree.TerminalNode;
import org.eclipse.lsp4j.CompletionItem;
import org.eclipse.lsp4j.CompletionParams;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.Collectors;

public abstract class AbstractCompletionVisitors extends alloyBaseVisitor<List<CompletionItem>> {

	protected String alloyText;
	protected CompletionParams completionParams;
	protected AlloyEvaluation alloyEvaluation;
	protected Map<String, alloyParser.ExprContext> quantifiers;

	public AbstractCompletionVisitors(String alloyText,
	                                  CompletionParams completionParams,
	                                  AlloyEvaluation alloyEvaluation) {
		this.alloyText = alloyText;
		this.completionParams = completionParams;
		this.alloyEvaluation = alloyEvaluation;
	}

	public AbstractCompletionVisitors(String alloyText,
	                                  CompletionParams completionParams,
	                                  AlloyEvaluation alloyEvaluation,
	                                  Map<String, alloyParser.ExprContext> quantifiers) {
		this.alloyText = alloyText;
		this.completionParams = completionParams;
		this.alloyEvaluation = alloyEvaluation;
		this.quantifiers = quantifiers;
	}

	protected boolean isCompletionTriggeringLine(ParserRuleContext ctx) {
		return completionParams.getPosition().getLine() == ctx.getStop().getLine() - 1;
	}

	protected boolean shouldVisitDeeper(alloyParser.ExprContext ctx) {
		if (ctx.children == null) {
			return false;
		}
		if (ctx.getChildCount() > 0 && ctx.getChild(0).getText().equals("let")) {
			return true;
		}
		if (ctx.getChild(0).getText().equals("(") && !ctx.getChild(ctx.getChildCount() - 1).getText().equals(")")) {
			return true;
		}
		if (ctx.quant() != null) {
			return true;
		}
		if (ctx.implicationOp() != null) {
			return true;
		}
		if (ctx.binOp() != null) {
			return true;
		}
		if (ctx.unOp() != null) {
			return true;
		}
		if (ctx.expr().size() > 1 && ctx.compareOp() != null && ctx.expr(ctx.expr().size() - 1).children != null) {
			return true;
		}
		if (ctx.getChild(1) instanceof TerminalNode && ctx.getChild(1).getText().equals("else")) {
			return true;
		}
		if (ctx.getChild(ctx.getChildCount() - 1) instanceof ErrorNodeImpl) {
			return true;
		}
		return false;
	}

	public static <T> Predicate<T> distinctByKey(Function<? super T, ?> keyExtractor) {

		Map<Object, Boolean> seen = new ConcurrentHashMap<>();
		return t -> seen.putIfAbsent(keyExtractor.apply(t), Boolean.TRUE) == null;
	}

	public String getInvalidTokenText(ParserRuleContext ctx) {
		return ctx.exception instanceof org.antlr.v4.runtime.NoViableAltException ?
				((org.antlr.v4.runtime.NoViableAltException) ctx.exception).getStartToken().getText() :
				ctx.getStop().getText();
	}

	@Override
	protected List<CompletionItem> aggregateResult(List<CompletionItem> aggregate, List<CompletionItem> nextResult) {
		aggregate.addAll(nextResult);
		return aggregate.stream()
		                .filter(completionItem -> !completionItem.getLabel().isEmpty())
		                .filter(distinctByKey(CompletionItem::getLabel))
		                .sorted(Comparator.comparing(CompletionItem::getSortText))
		                .collect(Collectors.toList());
	}

	@Override
	protected List<CompletionItem> defaultResult() {
		return new ArrayList<>();
	}
}
