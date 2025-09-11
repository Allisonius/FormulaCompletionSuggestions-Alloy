package alloy.language.server.utils;

import alloy.language.server.alloyParser;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.utils.AlloyEvaluation;
import alloy.language.server.utils.AlloyExpressionParsingUtils;
import alloy.language.server.visitors.BaseVisitorTest;
import org.eclipse.lsp4j.CompletionItem;
import org.eclipse.lsp4j.CompletionParams;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;

public class QuantifierParsingTest extends BaseVisitorTest {

	private alloyParser.ExprContext buildExpression(String expr) {
		CompletionModelBuilder modelBuilder = CompletionModelBuilder.modelBuilder();
		String model = modelBuilder.withCompletionLine(expr).build();

		alloyParser parser = buildParser(model);
		return parser.expr();
	}

	@Test
	public void testSingleQuantifiedExpression() {
		String model = "all x: Class | some x";
		var tree = buildExpression(model);
		Map<String, alloyParser.ExprContext> quantifierMap =
				AlloyExpressionParsingUtils.getQuantifierMap(tree, Map.of());
		var expr = (alloyParser.ExprContext) tree.getChild(2).getChild(1);
		var result = AlloyExpressionParsingUtils.parseExpWithQuantifier(expr, quantifierMap);
		System.out.println(result.getText());
		assertThat(result.expr().get(0).getText(), is("Class"));
	}

	@Test
	public void testExpWithQualifiers() {
		String model = "all x: Student | some x.Class";
		var tree = buildExpression(model);
		Map<String, alloyParser.ExprContext> quantifierMap =
				AlloyExpressionParsingUtils.getQuantifierMap(tree, Map.of());
		var expr = (alloyParser.ExprContext) tree.getChild(tree.getChildCount() - 1).getChild(1);
		System.out.println(expr.getText());
		var result = AlloyExpressionParsingUtils.parseExpWithQuantifier(expr, quantifierMap);
		System.out.println(result.getText());
		assertThat(result.getText(), is("someStudent.Class"));
	}

	@Test
	public void testExpWithMultipleQuantifiers() {
		String model = "all x: Student, y: Class | some x.y";
		var tree = buildExpression(model);
		Map<String, alloyParser.ExprContext> quantifierMap = AlloyExpressionParsingUtils.getQuantifierMap(tree, Map.of());
		var expr = (alloyParser.ExprContext) tree.getChild(tree.getChildCount() - 1).getChild(1);
		System.out.println(expr.getText());
		var result = AlloyExpressionParsingUtils.parseExpWithQuantifier(expr, quantifierMap);
		System.out.println(result.getText());
		assertThat(result.getText(), is("someStudent.Class"));
	}

	@Test
	public void testExpWithExpressionInQuantifiers() {
		String model = "all x: Student, y: x.Class | some y.Teacher";
		var tree = buildExpression(model);
		Map<String, alloyParser.ExprContext> quantifierMap = AlloyExpressionParsingUtils.getQuantifierMap(tree, Map.of());
		var expr = (alloyParser.ExprContext) tree.getChild(tree.getChildCount() - 1).getChild(1);
		System.out.println(expr.getText());
		var result = AlloyExpressionParsingUtils.parseExpWithQuantifier(expr, quantifierMap);
		System.out.println(result.getText());
		assertThat(result.getText(), is("someStudent.Class.Teacher"));
	}

	@Test
	public void testExpWithSetOperators() {
		String model = "all x: Student | some x.Class & x.Teacher";
		var tree = buildExpression(model);
		Map<String, alloyParser.ExprContext> quantifierMap = AlloyExpressionParsingUtils.getQuantifierMap(tree, Map.of());
		var expr = (alloyParser.ExprContext) tree.getChild(tree.getChildCount() - 1).getChild(1);
		System.out.println(expr.getText());
		var result = AlloyExpressionParsingUtils.parseExpWithQuantifier(expr, quantifierMap);
		System.out.println(result.getText());
		assertThat(result.getText(), is("someStudent.Class&Student.Teacher"));
	}

	@Test
	public void testExpWithSetOperatorsAndDifferentQuantifiers() {
		String model = "all x: Student | some x.Class & x.Teacher";
		var tree = buildExpression(model);
		Map<String, alloyParser.ExprContext> quantifierMap = AlloyExpressionParsingUtils.getQuantifierMap(tree, Map.of());
		var expr = (alloyParser.ExprContext) tree.getChild(tree.getChildCount() - 1).getChild(1);
		System.out.println(expr.getText());
		var result = AlloyExpressionParsingUtils.parseExpWithQuantifier(expr, quantifierMap);
		System.out.println(result.getText());
		assertThat(result.getText(), is("someStudent.Class&Student.Teacher"));
	}

	@Test
	public void testExpWithIncompleteLine() {
		String model = "all x: Student | some x.Class & x.";
		var tree = buildExpression(model);
		Map<String, alloyParser.ExprContext> quantifierMap = AlloyExpressionParsingUtils.getQuantifierMap(tree, Map.of());
		var expr = (alloyParser.ExprContext) tree.getChild(tree.getChildCount() - 1).getChild(1);
		System.out.println(expr.getText());
		var result = AlloyExpressionParsingUtils.parseExpWithQuantifier(expr, quantifierMap);
		System.out.println(result.getText());
		assertThat(result.getText(), is("someStudent.Class&Student"));
	}
}
