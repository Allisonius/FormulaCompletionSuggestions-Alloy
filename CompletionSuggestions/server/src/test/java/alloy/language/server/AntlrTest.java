package alloy.language.server;

import alloy.language.server.utils.data.ParsingErrorCursor;
import alloy.language.server.visitors.helpers.AlloySyntaxParsingVisitor;
import alloy.language.server.visitors.helpers.AlloySyntaxErrorListener;
import edu.mit.csail.sdg.alloy4.Err;
import edu.mit.csail.sdg.parser.CompUtil;
import org.antlr.v4.runtime.*;
import org.junit.jupiter.api.Test;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class AntlrTest {

	private static String demo() {
		return String.join(
				"\n",
				"sig Person {}",
				"sig Student in Person {}",
				"sig Teacher in Person {}",
				"sig Group {}",
				"sig Class { Groups: Person -> Group }",
				"pred abc {",
				"    some Class.Groups",
				"    no Teacher & ",
				//				"    some Class.Groups",
				"}",
				"fact f1 {",
				"   no Teacher & Student",
				"}",
				"pred p2 {",
				"   some Class.",
				"}",
				"pred p3 {",
				"   some p.",
				"}",
				"pred dummy {}",
				"run dummy for 3");
	}

	@Test
	public void test() {
		CharStream inputStream = CharStreams.fromString(demo());
		alloyLexer alloyLexer = new alloyLexer(inputStream);
		CommonTokenStream commonTokenStream = new CommonTokenStream(alloyLexer);
		var parser = new alloyParser(commonTokenStream);

		parser.removeErrorListeners();
		var errorListener = new AlloySyntaxErrorListener();
		parser.addErrorListener(errorListener);

		System.out.println(demo());

		var tree = parser.alloyModule();

		var parsingErrors = errorListener.getParsingErrors();
		for (ParsingErrorCursor error : parsingErrors) {
//			System.out.println("Error at line " + error.errorLine + ":" + error.errorCharacter + " " + error.message);
			System.out.println("Removable context: " + error.removableContext.getText());
		}

		AlloySyntaxParsingVisitor visitor = new AlloySyntaxParsingVisitor(errorListener.getRemovableRuleContexts());
		String alloyText = visitor.visitAlloyModule(tree);
		System.out.println("Error free text:");
//		System.out.println(alloyText);

		String originalText = demo();
		var lines = originalText.split("\n");
		parsingErrors.stream().flatMap(parsingErrorCursor -> parsingErrorCursor.getErrorLines().stream()).collect(Collectors.toSet()).forEach(line -> {
			lines[line] = "";
		});

		StringBuilder sb = new StringBuilder();
		for (String line : lines) {
			sb.append(line).append("\n");
		}
		System.out.println(sb.toString());

		try {
			var world = CompUtil.parseEverything_fromString(null, alloyText);
			System.out.println(world.getAllSigs());
		} catch (Err ex) {
			System.err.println(ex.pos);
			System.err.println(ex.msg);
		}
	}
}
