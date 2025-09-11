package alloy.language.server.utils.data;

import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.RuleContext;
import org.eclipse.lsp4j.Position;

import java.util.ArrayList;
import java.util.List;

public class ParsingErrorCursor {
//	public final int errorLine;
//	public final int errorCharacter;
	public final Position start;
	public final Position end;
	public final String message;
	public final ParserRuleContext removableContext;

//	public ParsingErrorCursor(
//			int errorLine, int errorCharacter, String message, RuleContext removableContext) {
//		this.errorLine = errorLine;
//		this.errorCharacter = errorCharacter;
//		this.message = message;
//		this.removableContext = removableContext;
//	}


	public ParsingErrorCursor(
			Position start, Position end, String message, ParserRuleContext removableContext) {
		this.start = start;
		this.end = end;
		this.message = message;
		this.removableContext = removableContext;
	}

	public RuleContext getRemovableContext() {
		return removableContext;
	}

	public List<Integer> getErrorLines() {
		List<Integer> errorLines = new ArrayList<>();
		for (int i = start.getLine(); i <= end.getLine() ; i++) {
			errorLines.add(i);
		}
		return errorLines;
	}
}
