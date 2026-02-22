package alloy.language.server.utils;

import alloy.language.server.alloyParser;
import alloy.language.server.visitors.BaseVisitorTest;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class FindCompletionTermExpressionTest extends BaseVisitorTest {

	@Test
	public void testFindSimpleCompletionTerm() {
		String expression = "Person";
		alloyParser.ExprContext expr = AlloyExpressionParsingUtils.buildExprContextFromString(expression);
		var completionTerm = AlloyExpressionParsingUtils.findCompletionTermExpression(expr);
		assertThat(completionTerm, is(notNullValue()));
		assertThat(completionTerm.getText(), is("Person"));
	}

	@Test
	public void testFindDotJoinedTerm() {
		String expression = "Person.Student";
		alloyParser.ExprContext expr = AlloyExpressionParsingUtils.buildExprContextFromString(expression);
		var completionTerm = AlloyExpressionParsingUtils.findCompletionTermExpression(expr);
		assertThat(completionTerm, is(notNullValue()));
		assertThat(completionTerm.getText(), is("Person.Student"));
	}

	@Test
	public void testFindTermWithBinOp() {
		String expression = "Person + Student";
		alloyParser.ExprContext expr = AlloyExpressionParsingUtils.buildExprContextFromString(expression);
		var completionTerm = AlloyExpressionParsingUtils.findCompletionTermExpression(expr);
		assertThat(completionTerm, is(notNullValue()));
		assertThat(completionTerm.getText(), is("Student"));
	}

	@Test
	public void testFindTermWithUnOp() {
		String expression = "some Person";
		alloyParser.ExprContext expr = AlloyExpressionParsingUtils.buildExprContextFromString(expression);
		var completionTerm = AlloyExpressionParsingUtils.findCompletionTermExpression(expr);
		assertThat(completionTerm, is(notNullValue()));
		assertThat(completionTerm.getText(), is("Person"));
	}

	@Test
	public void testFindTermWithArrowOp() {
		String expression = "Person -> Course";
		alloyParser.ExprContext expr = AlloyExpressionParsingUtils.buildExprContextFromString(expression);
		var completionTerm = AlloyExpressionParsingUtils.findCompletionTermExpression(expr);
		assertThat(completionTerm, is(notNullValue()));
		assertThat(completionTerm.getText(), is("Person->Course"));
	}

	@Test
	public void testFindTermWithParentheses() {
		String expression = "(Person + Student).age";
		alloyParser.ExprContext expr = AlloyExpressionParsingUtils.buildExprContextFromString(expression);
		var completionTerm = AlloyExpressionParsingUtils.findCompletionTermExpression(expr);
		assertThat(completionTerm, is(notNullValue()));
		assertThat(completionTerm.getText(), is("(Person+Student).age"));
	}

	@Test
	public void testFindTermWithIncompleteParentheses() {
		String expression = "Person).age";
		alloyParser.ExprContext expr = AlloyExpressionParsingUtils.buildExprContextFromString(expression);
		var completionTerm = AlloyExpressionParsingUtils.findCompletionTermExpression(expr);
		assertThat(completionTerm, is(notNullValue()));
		assertThat(completionTerm.getText(), is("Person"));
	}

	@Test
	public void testFindTermWithComplexExpression() {
		String expression = "p.(c.grades) implies some p.projects & c.projects";
		alloyParser.ExprContext expr = AlloyExpressionParsingUtils.buildExprContextFromString(expression);
		var completionTerm = AlloyExpressionParsingUtils.findCompletionTermExpression(expr);
		assertThat(completionTerm, is(notNullValue()));
		assertThat(completionTerm.getText(), is("c.projects"));
	}

	@Test
	public void testFindTermWithComplexExpression2() {
		String expression = "p.(c.grades) implies some p.projects & c.projects + Person";
		alloyParser.ExprContext expr = AlloyExpressionParsingUtils.buildExprContextFromString(expression);
		var completionTerm = AlloyExpressionParsingUtils.findCompletionTermExpression(expr);
		assertThat(completionTerm, is(notNullValue()));
		assertThat(completionTerm.getText(), is("Person"));
	}

	@Test
	public void testFindTermWithNumberOp() {
		String expression = "#Person";
		alloyParser.ExprContext expr = AlloyExpressionParsingUtils.buildExprContextFromString(expression);
		var completionTerm = AlloyExpressionParsingUtils.findCompletionTermExpression(expr);
		assertThat(completionTerm, is(notNullValue()));
		assertThat(completionTerm.getText(), is("Person"));
	}

	@Test
	public void testFindTermWithImpliesElse() {
		String expression = "p.(c.grades) implies some p.projects else c.projects";
		alloyParser.ExprContext expr = AlloyExpressionParsingUtils.buildExprContextFromString(expression);
		var completionTerm = AlloyExpressionParsingUtils.findCompletionTermExpression(expr);
		assertThat(completionTerm, is(notNullValue()));
		assertThat(completionTerm.getText(), is("c.projects"));
	}
}
