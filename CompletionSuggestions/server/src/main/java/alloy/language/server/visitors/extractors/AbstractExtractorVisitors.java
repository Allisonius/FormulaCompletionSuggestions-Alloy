package alloy.language.server.visitors.extractors;

import alloy.language.server.alloyBaseVisitor;
import alloy.language.server.alloyParser;
import org.antlr.v4.runtime.ParserRuleContext;
import org.eclipse.lsp4j.CompletionParams;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public abstract class AbstractExtractorVisitors extends alloyBaseVisitor<Map<String, alloyParser.ExprContext>> {
	protected String alloyText;
	protected CompletionParams completionParams;
	protected Map<String, alloyParser.ExprContext> existingDeclarations;

	public AbstractExtractorVisitors(String alloyText, CompletionParams completionParams) {
		this.alloyText = alloyText;
		this.completionParams = completionParams;
		this.existingDeclarations = new ConcurrentHashMap<>();
	}

	public AbstractExtractorVisitors(String alloyText,
	                                 CompletionParams completionParams,
	                                 Map<String, alloyParser.ExprContext> existingDeclarations) {
		this.alloyText = alloyText;
		this.completionParams = completionParams;
		this.existingDeclarations = existingDeclarations;
	}

	protected boolean isCompletionTriggeringLine(ParserRuleContext ctx) {
		return completionParams.getPosition().getLine() == ctx.getStop().getLine() - 1;
	}

	@Override
	protected Map<String, alloyParser.ExprContext> aggregateResult(Map<String, alloyParser.ExprContext> aggregate,
	                                                               Map<String, alloyParser.ExprContext> nextResult) {
		var newAggregate = new ConcurrentHashMap<>(Map.copyOf(aggregate));
		newAggregate.putAll(nextResult);
		return newAggregate;
	}

	@Override
	protected Map<String, alloyParser.ExprContext> defaultResult() {
		return Map.of();
	}
}
