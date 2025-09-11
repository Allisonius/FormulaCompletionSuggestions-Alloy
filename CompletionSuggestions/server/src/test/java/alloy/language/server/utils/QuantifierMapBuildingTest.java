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
import static org.hamcrest.Matchers.*;

public class QuantifierMapBuildingTest extends BaseVisitorTest {

	private alloyParser.ExprContext buildExpression(String expr) {
		CompletionModelBuilder modelBuilder = CompletionModelBuilder.modelBuilder();
		String model = modelBuilder.withCompletionLine(expr).build();

		alloyParser parser = buildParser(model);
		return parser.expr();
	}

	@Test
	public void testSingleQuantifier() {
		String model = "all x: Class | x";
		var tree = buildExpression(model);
		Map<String, alloyParser.ExprContext> quantifierMap = AlloyExpressionParsingUtils.getQuantifierMap(tree, Map.of());
		System.out.println(quantifierMap);
		assertThat(quantifierMap.size(), is(1));
		assertThat(quantifierMap.containsKey("x"), is(true));
		var quantifier = quantifierMap.get("x");
		System.out.println(quantifier.getText());
		assertThat(quantifier.getText(), is("Class"));
	}

	@Test
	public void testMultipleQuantifiers() {
		String model = "all x, y: Class | x";
		var tree = buildExpression(model);
		Map<String, alloyParser.ExprContext> quantifierMap = AlloyExpressionParsingUtils.getQuantifierMap(tree, Map.of());
		System.out.println(quantifierMap);
		assertThat(quantifierMap.size(), is(2));
		assertThat(quantifierMap.containsKey("x"), is(true));
		assertThat(quantifierMap.containsKey("y"), is(true));
		var typeOfX = quantifierMap.get("x");
		var typeOfY = quantifierMap.get("y");
		assertThat(typeOfX.getText(), is("Class"));
		assertThat(typeOfY.getText(), is("Class"));
	}

	@Test
	public void testExpressionQuantifiers() {
		String model = "all x: Class, y: x.Student | some y";
		var tree = buildExpression(model);
		Map<String, alloyParser.ExprContext> quantifierMap = AlloyExpressionParsingUtils.getQuantifierMap(tree, Map.of());

		assertThat(quantifierMap.size(), is(2));
		assertThat(quantifierMap.containsKey("x"), is(true));
		assertThat(quantifierMap.containsKey("y"), is(true));
		var typeOfX = quantifierMap.get("x");
		var typeOfY = quantifierMap.get("y");
		assertThat(typeOfX.getText(), is("Class"));
		assertThat(typeOfY.getText(), is("(Class.Student)"));
	}
}
