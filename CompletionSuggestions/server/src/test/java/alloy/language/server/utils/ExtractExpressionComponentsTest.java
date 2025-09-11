package alloy.language.server.utils;

import alloy.language.server.params.EvaluateSuggestions;
import org.junit.jupiter.api.Test;

import java.util.List;
import java.util.Set;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class ExtractExpressionComponentsTest {

	public static final Set<String> SIGNATURES = Set.of("Person", "Student", "Teacher", "Admin", "Staff", "Class");
	public static final Set<String> RELATIONS = Set.of("teaches", "enrolls", "projects");

	@Test
	public void testExtractExpressionComponents() {
		String expression = "Person";
		var expectedComponents = AlloyExpressionParsingUtils.extractExpressionComponents(expression, SIGNATURES, RELATIONS, Set.of());
		assertThat(expectedComponents.size(), is(1));
		assertThat(expectedComponents.getFirst().label(), is("Person"));
		assertThat(expectedComponents.getFirst().type(), is(EvaluateSuggestions.ExpressionComponent.ComponentType.SIGNATURE.name()));
	}

	@Test
	public void testExtractExpressionComponentsWithDot() {
		String expression = "Person.Student";
		var expectedComponents = AlloyExpressionParsingUtils.extractExpressionComponents(expression, SIGNATURES, RELATIONS, Set.of());
		assertThat(expectedComponents.size(), is(3));
		assertThat(expectedComponents, is(List.of(
				new EvaluateSuggestions.ExpressionComponent("Person", EvaluateSuggestions.ExpressionComponent.ComponentType.SIGNATURE),
				new EvaluateSuggestions.ExpressionComponent(".", EvaluateSuggestions.ExpressionComponent.ComponentType.OPERATOR),
				new EvaluateSuggestions.ExpressionComponent("Student", EvaluateSuggestions.ExpressionComponent.ComponentType.SIGNATURE)
		)));
	}

	@Test
	public void testExtractExpressionComponentsWithRelations() {
		String expression = "Person.teaches.Student";
		var expectedComponents = AlloyExpressionParsingUtils.extractExpressionComponents(expression, SIGNATURES, RELATIONS, Set.of());
		assertThat(expectedComponents.size(), is(5));
		assertThat(expectedComponents, is(List.of(
			new EvaluateSuggestions.ExpressionComponent("Person", EvaluateSuggestions.ExpressionComponent.ComponentType.SIGNATURE),
			new EvaluateSuggestions.ExpressionComponent(".", EvaluateSuggestions.ExpressionComponent.ComponentType.OPERATOR),
			new EvaluateSuggestions.ExpressionComponent("teaches", EvaluateSuggestions.ExpressionComponent.ComponentType.RELATION),
			new EvaluateSuggestions.ExpressionComponent(".", EvaluateSuggestions.ExpressionComponent.ComponentType.OPERATOR),
			new EvaluateSuggestions.ExpressionComponent("Student", EvaluateSuggestions.ExpressionComponent.ComponentType.SIGNATURE)
		)));
	}

	@Test
	public void testExtractExpressionComponentsWithVariables() {
		String expression = "x + y";
		var expectedComponents = AlloyExpressionParsingUtils.extractExpressionComponents(expression, SIGNATURES, RELATIONS, Set.of("x", "y"));
		assertThat(expectedComponents.size(), is(3));
		assertThat(expectedComponents, is(List.of(
			new EvaluateSuggestions.ExpressionComponent("x", EvaluateSuggestions.ExpressionComponent.ComponentType.VARIABLE),
			new EvaluateSuggestions.ExpressionComponent("+", EvaluateSuggestions.ExpressionComponent.ComponentType.OPERATOR),
			new EvaluateSuggestions.ExpressionComponent("y", EvaluateSuggestions.ExpressionComponent.ComponentType.VARIABLE)
		)));
	}

	@Test
	public void testExtractExpressionComponentsWithMultipleDots() {
		String expression = "Person.Student.Class";
		var expectedComponents = AlloyExpressionParsingUtils.extractExpressionComponents(expression, SIGNATURES, RELATIONS, Set.of());
		assertThat(expectedComponents.size(), is(5));
		assertThat(expectedComponents, is(List.of(
			new EvaluateSuggestions.ExpressionComponent("Person", EvaluateSuggestions.ExpressionComponent.ComponentType.SIGNATURE),
			new EvaluateSuggestions.ExpressionComponent(".", EvaluateSuggestions.ExpressionComponent.ComponentType.OPERATOR),
			new EvaluateSuggestions.ExpressionComponent("Student", EvaluateSuggestions.ExpressionComponent.ComponentType.SIGNATURE),
			new EvaluateSuggestions.ExpressionComponent(".", EvaluateSuggestions.ExpressionComponent.ComponentType.OPERATOR),
			new EvaluateSuggestions.ExpressionComponent("Class", EvaluateSuggestions.ExpressionComponent.ComponentType.SIGNATURE)
		)));
	}

	@Test
	public void testExtractExpressionComponentsWithLogicalOperators() {
		String expression = "Person + Student";
		var expectedComponents = AlloyExpressionParsingUtils.extractExpressionComponents(expression, SIGNATURES, RELATIONS, Set.of());
		assertThat(expectedComponents.size(), is(3));
		assertThat(expectedComponents, is(List.of(
			new EvaluateSuggestions.ExpressionComponent("Person", EvaluateSuggestions.ExpressionComponent.ComponentType.SIGNATURE),
			new EvaluateSuggestions.ExpressionComponent("+", EvaluateSuggestions.ExpressionComponent.ComponentType.OPERATOR),
			new EvaluateSuggestions.ExpressionComponent("Student", EvaluateSuggestions.ExpressionComponent.ComponentType.SIGNATURE)
		)));
	}

	@Test
	public void testExtractExpressionComponentsWithComplexExpression() {
		String expression = "Person + Student.Class - Teacher";
		var expectedComponents = AlloyExpressionParsingUtils.extractExpressionComponents(expression, SIGNATURES, RELATIONS, Set.of());
		assertThat(expectedComponents.size(), is(7));
		assertThat(expectedComponents, is(List.of(
			new EvaluateSuggestions.ExpressionComponent("Person", EvaluateSuggestions.ExpressionComponent.ComponentType.SIGNATURE),
			new EvaluateSuggestions.ExpressionComponent("+", EvaluateSuggestions.ExpressionComponent.ComponentType.OPERATOR),
			new EvaluateSuggestions.ExpressionComponent("Student", EvaluateSuggestions.ExpressionComponent.ComponentType.SIGNATURE),
			new EvaluateSuggestions.ExpressionComponent(".", EvaluateSuggestions.ExpressionComponent.ComponentType.OPERATOR),
			new EvaluateSuggestions.ExpressionComponent("Class", EvaluateSuggestions.ExpressionComponent.ComponentType.SIGNATURE),
			new EvaluateSuggestions.ExpressionComponent("-", EvaluateSuggestions.ExpressionComponent.ComponentType.OPERATOR),
			new EvaluateSuggestions.ExpressionComponent("Teacher", EvaluateSuggestions.ExpressionComponent.ComponentType.SIGNATURE)
		)));
	}

	@Test
	public void testExtractExpressionComponentsWithParentheses() {
		String expression = "(Person + Student) & Teacher";
		var expectedComponents = AlloyExpressionParsingUtils.extractExpressionComponents(expression, SIGNATURES, RELATIONS, Set.of());
		assertThat(expectedComponents.size(), is(5));
		assertThat(expectedComponents, is(List.of(
			new EvaluateSuggestions.ExpressionComponent("Person", EvaluateSuggestions.ExpressionComponent.ComponentType.SIGNATURE),
			new EvaluateSuggestions.ExpressionComponent("+", EvaluateSuggestions.ExpressionComponent.ComponentType.OPERATOR),
			new EvaluateSuggestions.ExpressionComponent("Student", EvaluateSuggestions.ExpressionComponent.ComponentType.SIGNATURE),
			new EvaluateSuggestions.ExpressionComponent("&", EvaluateSuggestions.ExpressionComponent.ComponentType.OPERATOR),
			new EvaluateSuggestions.ExpressionComponent("Teacher", EvaluateSuggestions.ExpressionComponent.ComponentType.SIGNATURE)
		)));
	}

	@Test
	public void testExtractExpressionComponentsWithNestedParentheses() {
		String expression = "(Person + (Student.Class - Teacher)) & (Admin || Staff)";
		var expectedComponents = AlloyExpressionParsingUtils.extractExpressionComponents(expression, SIGNATURES, RELATIONS, Set.of());
		System.out.println(expectedComponents);
		assertThat(expectedComponents.size(), is(11));
		assertThat(expectedComponents, is(List.of(
			new EvaluateSuggestions.ExpressionComponent("Person", EvaluateSuggestions.ExpressionComponent.ComponentType.SIGNATURE),
			new EvaluateSuggestions.ExpressionComponent("+", EvaluateSuggestions.ExpressionComponent.ComponentType.OPERATOR),
			new EvaluateSuggestions.ExpressionComponent("Student", EvaluateSuggestions.ExpressionComponent.ComponentType.SIGNATURE),
			new EvaluateSuggestions.ExpressionComponent(".", EvaluateSuggestions.ExpressionComponent.ComponentType.OPERATOR),
			new EvaluateSuggestions.ExpressionComponent("Class", EvaluateSuggestions.ExpressionComponent.ComponentType.SIGNATURE),
			new EvaluateSuggestions.ExpressionComponent("-", EvaluateSuggestions.ExpressionComponent.ComponentType.OPERATOR),
			new EvaluateSuggestions.ExpressionComponent("Teacher", EvaluateSuggestions.ExpressionComponent.ComponentType.SIGNATURE),
			new EvaluateSuggestions.ExpressionComponent("&", EvaluateSuggestions.ExpressionComponent.ComponentType.OPERATOR),
			new EvaluateSuggestions.ExpressionComponent("Admin", EvaluateSuggestions.ExpressionComponent.ComponentType.SIGNATURE),
			new EvaluateSuggestions.ExpressionComponent("||", EvaluateSuggestions.ExpressionComponent.ComponentType.OPERATOR),
			new EvaluateSuggestions.ExpressionComponent("Staff", EvaluateSuggestions.ExpressionComponent.ComponentType.SIGNATURE)
		)));
	}

	@Test
	public void testWithStarOperator() {
		String expression = "*teaches";
		var expectedComponents = AlloyExpressionParsingUtils.extractExpressionComponents(expression, SIGNATURES, RELATIONS, Set.of());
		assertThat(expectedComponents.size(), is(2));
		assertThat(expectedComponents, is(List.of(
			new EvaluateSuggestions.ExpressionComponent("*", EvaluateSuggestions.ExpressionComponent.ComponentType.OPERATOR),
			new EvaluateSuggestions.ExpressionComponent("teaches", EvaluateSuggestions.ExpressionComponent.ComponentType.RELATION)
		)));
	}

	@Test
	public void testExtractExpressionComponentsWithEmptyExpression() {
		String expression = "";
		var expectedComponents = AlloyExpressionParsingUtils.extractExpressionComponents(expression, SIGNATURES, RELATIONS, Set.of());
		assertThat(expectedComponents.size(), is(0));
		assertThat(expectedComponents, is(empty()));
	}
}
