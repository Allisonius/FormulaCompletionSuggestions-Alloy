package alloy.language.server.utils;

import alloy.language.server.alloyLexer;
import alloy.language.server.alloyParser;
import alloy.language.server.utils.data.SuggestionTerm;
import arepair.generator.CompatUtils;
import edu.mit.csail.sdg.alloy4.A4Reporter;
import edu.mit.csail.sdg.alloy4.Pos;
import edu.mit.csail.sdg.ast.Expr;
import edu.mit.csail.sdg.ast.Sig;
import edu.mit.csail.sdg.ast.Type;
import edu.mit.csail.sdg.parser.CompModule;
import edu.mit.csail.sdg.parser.CompUtil;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.eclipse.lsp4j.CompletionParams;
import org.eclipse.lsp4j.Position;
import org.eclipse.lsp4j.Range;
import org.slf4j.Logger;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class CodeUtils {
    private static final Logger logger = org.slf4j.LoggerFactory.getLogger(CodeUtils.class);

	public static final Set<String> LOGICAL_OPERATORS = Set.of("and", "or", "implies", "iff", "not", "&&", "||", "=>", "<=>");
	public static final Set<String> SET_OPERATORS = Set.of("in", "+", "&", "-", ".", "=");
	public static final Set<String> UNARY_OPERATORS = Set.of("!", "*", "^");

	public static String getAlloyTextWithoutCompletionLine(String alloyText, CompletionParams completionParams) {
		String[] lines = alloyText.split("\n");
		StringBuilder alloyTextWithoutCompletionLine = new StringBuilder();
		for (int i = 0; i < lines.length; i++) {
			if (i == completionParams.getPosition().getLine()) {
				continue;
			}
			alloyTextWithoutCompletionLine.append(lines[i]).append("\n");
		}
		return alloyTextWithoutCompletionLine.toString();
	}

	public static CompModule getCompModule(String alloyText) {
		try {
			return CompUtil.parseEverything_fromString(new A4Reporter(), alloyText);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	public static alloyParser buildAlloyParser(String documentText) {
		CharStream inputStream = CharStreams.fromString(documentText);
		alloyLexer alloyLexer = new alloyLexer(inputStream);
		CommonTokenStream commonTokenStream = new CommonTokenStream(alloyLexer);
		return new alloyParser(commonTokenStream);
	}

	public static String formatLabel(String label) {
		return label.replace("this/", "").replace("{", "").replace("}", "");
	}

	public static String formatLabel(Type type) {
		return formatLabel(type.toString());
	}

	public static String formatLabel(Sig sig) {
		return formatLabel(sig.label);
	}

	public static String formatLabel(Sig.PrimSig primSig) {
		return formatLabel(primSig.label);
	}

	public static String formatLabel(Sig.Field field) {
		return formatLabel(field.label);
	}

	public static Expr buildAlloyExpression(CompModule world, String expr) {
		try {
			return world.parseOneExpressionFromString(expr);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	public static Type getType(CompModule world, String expr) {
		Expr expression = buildAlloyExpression(world, expr);
		return expression != null ? expression.type() : null;
	}

	public static Range getRangeFromPos(Pos pos) {
		var start = new Position(pos.y - 1, pos.x);
		var end = new Position(pos.y2 - 1, pos.x2);
		return new Range(start, end);
	}

	public static Type getTypeOfExpression(alloyParser.ExprContext expr, CompModule world) {
		return getTypeOfExpression(AlloyExpressionParsingUtils.textFromExpr(expr), world);
	}

	public static Type getTypeOfExpression(String expr, CompModule world) {
		if (expr == null || expr.isEmpty() || expr.equals("none")) {
			return null;
		}
		try {
			return world.parseOneExpressionFromString(expr).type();
		} catch (IOException e) {
			logger.error("Error while parsing expression: {}", expr, e);
			return null;
		}
	}

	public static List<SuggestionTerm> suggestionListFromQuantifiers(Map<String, alloyParser.ExprContext> quantifiers,
	                                                                 CompModule world) {
		List<SuggestionTerm> suggestions = new ArrayList<>();
		for (var quantifier : quantifiers.entrySet()) {
			var type = getTypeOfExpression(quantifier.getValue(), world);
			if (type != null) {
				var expression = CompatUtils.createExpression(quantifier.getKey(), type);
				suggestions.add(new SuggestionTerm(quantifier.getKey(), type, SuggestionTerm.Degree.QUANTIFIER,
				                                   expression));
				if (type.arity() == 2) {
					suggestions.add(new SuggestionTerm("~" + quantifier.getKey(), CodeUtils.getType(world, "~" + type),
					                                   SuggestionTerm.Degree.EXTENDED_RELATION_1,
					                                   CompatUtils.buildExpression("~", expression)));
					var relationTypes = type.fold().get(0);
					if (CodeUtils.doesTypesMatch(relationTypes.get(0),relationTypes.get(1))) {
						suggestions.add(
								new SuggestionTerm("^" + quantifier.getKey(), type,
								                   SuggestionTerm.Degree.EXTENDED_RELATION_2, CompatUtils.buildExpression("^", expression)));
						suggestions.add(
								new SuggestionTerm("*" + quantifier.getKey(), type,
								                   SuggestionTerm.Degree.EXTENDED_RELATION_3, CompatUtils.buildExpression("*", expression)));
					}
				}
			}
		}
		return suggestions;
	}

	public static String getCuratedTextAfterRemovingLinesInRange(String originalText, int startLine, int endLine) {
		var lines = originalText.split("\n");
		Set<Integer> removableLines = IntStream.range(startLine, endLine - 1).boxed().collect(Collectors.toSet());

		StringBuilder curatedSyntax = new StringBuilder();
		for (int i = 0; i < lines.length; i++) {
			if (removableLines.contains(i)) {
				curatedSyntax.append("\n");
			} else {
				curatedSyntax.append(lines[i]).append("\n");
			}
		}
		return curatedSyntax.toString();
	}

	public static String getCuratedTextAfterRemovingLinesInRange(String originalText, CompletionParams completionParams, Position endOfBlock) {
		return getCuratedTextAfterRemovingLinesInRange(originalText, completionParams.getPosition().getLine() + 1, endOfBlock.getLine());
	}

	public static Boolean doesTypesMatch(Sig.PrimSig left, Sig.PrimSig right) {
		if (left.toString().equals("univ") || right.toString().equals("univ")) {
			return true;
		}

		if (left.type().arity() == 1) {
			var parent = left;
			while (parent != null && !parent.toString().equals("univ")) {
				if (parent.equals(right)) {
					return true;
				}
				parent = parent.parent;
			}
		}

		if (right.type().arity() == 1) {
			var parent = right;
			while (parent != null && !parent.toString().equals("univ")) {
				if (parent.equals(left)) {
					return true;
				}
				parent = parent.parent;
			}
		}

		return left.equals(right);
	}

	public static String findParent(Type type) {
		var parent = type.fold().getFirst().getFirst().parent;
		if (parent == null || parent.label.equals("univ")) {
			return null;
		}
		if (parent.parent.label.equals("univ")) {
			return parent.label;
		} else {
			return findParent(parent.type());
		}
	}

	public static Type findParentType(Type type) {
		var parent = type.fold().getFirst().getFirst().parent;
		if (parent == null || parent.label.equals("univ")) {
			return null;
		}
		if (parent.parent.label.equals("univ")) {
			return parent.type();
		} else {
			return findParentType(parent.type());
		}
	}
}
