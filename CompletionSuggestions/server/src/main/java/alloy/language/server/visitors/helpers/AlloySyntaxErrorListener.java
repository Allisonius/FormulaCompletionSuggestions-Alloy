package alloy.language.server.visitors.helpers;

import alloy.language.server.alloyParser;
import alloy.language.server.utils.data.ParsingErrorCursor;
import org.antlr.v4.runtime.*;
import org.eclipse.lsp4j.Position;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class AlloySyntaxErrorListener extends BaseErrorListener {

	private final List<ParsingErrorCursor> parsingErrors = new ArrayList<>();

	private ParserRuleContext findRemovableContext(ParserRuleContext ctx) {
		if (ctx instanceof alloyParser.ExprContext && (ctx.getParent() instanceof alloyParser.BlockContext || ctx.getParent() instanceof alloyParser.FunDeclContext)) {
			return ctx;
		}
		if (ctx instanceof alloyParser.DeclContext || ctx instanceof alloyParser.SigDeclContext) {
			return ctx;
		}

		if (ctx.getParent() != null) {
			return findRemovableContext(ctx.getParent());
		} else {
			return null;
		}
	}

	@Override
	public void syntaxError(
			Recognizer<?, ?> recognizer, Object offendingSymbol, int line, int charPositionInLine, String msg,
			RecognitionException e) {
		System.err.println("Offending symbol: " + offendingSymbol + " " + offendingSymbol.getClass());

		System.err.println("Recognizer: " + recognizer + " " + recognizer.getClass());
		if (recognizer instanceof Parser) {
			Parser parser = (Parser) recognizer;
			System.err.println("Parser rule context: " + parser.getRuleContext() + " " + parser.getRuleContext()
			                                                                                   .getText());
			if (parser.getRuleContext() != null) {
				var removableContext = findRemovableContext(parser.getRuleContext());
				if (removableContext != null) {
					Position start = new Position(
							removableContext.getStart()
							                .getLine() - 1,
							removableContext.getStart()
							                .getCharPositionInLine());
					Position end = new Position(start.getLine(), Integer.MAX_VALUE);
					parsingErrors.add(new ParsingErrorCursor(start, end, msg, removableContext));
				}
			}
		}
	}

	public List<ParsingErrorCursor> getParsingErrors() {
		return parsingErrors;
	}

	public List<RuleContext> getRemovableRuleContexts() {
		return parsingErrors.stream()
		                    .map(ParsingErrorCursor::getRemovableContext)
		                    .collect(Collectors.toList());
	}
}
