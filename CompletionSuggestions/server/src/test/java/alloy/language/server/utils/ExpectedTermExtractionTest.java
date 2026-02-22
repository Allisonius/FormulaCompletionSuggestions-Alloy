package alloy.language.server.utils;

import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class ExpectedTermExtractionTest {

	@Test
	public void testSimpleExtraction() {
		String expr = "Person + Student";
		var expectedTerms = AlloyExpressionParsingUtils.findLeadingExpression(expr);
		assertThat(expectedTerms, is("Person"));
	}

	@Test
	public void testExtractionWithDotOps() {
		String expr = "Person.Student";
		var expectedTerms = AlloyExpressionParsingUtils.findLeadingExpression(expr);
		assertThat(expectedTerms, is("Person.Student"));
	}

	@Test
	public void testExtractionWithParentheses() {
		String expr = "(Person + Student).age";
		var expectedTerms = AlloyExpressionParsingUtils.findLeadingExpression(expr);
		assertThat(expectedTerms, is("(Person+Student).age"));
	}

	@Test
	public void testExtractionWithUnOps() {
		String expr = "some Person";
		var expectedTerms = AlloyExpressionParsingUtils.findLeadingExpression(expr);
		assertThat(expectedTerms, is("Person"));
	}

	@Test
	public void testExtractionWithBinOps() {
		String expr = "Person + Student -> Course";
		var expectedTerms = AlloyExpressionParsingUtils.findLeadingExpression(expr);
		assertThat(expectedTerms, is("Person"));
	}

	@Test
	public void testExtractionWithArrowOp() {
		String expr = "Person -> Course";
		var expectedTerms = AlloyExpressionParsingUtils.findLeadingExpression(expr);
		assertThat(expectedTerms, is("Person"));
	}

	@Test
	public void testExtractionWithIncompleteParentheses() {
		String expr = "Person).age";
		var expectedTerms = AlloyExpressionParsingUtils.findLeadingExpression(expr);
		assertThat(expectedTerms, is("Person"));
	}

	//p.(c.grades) implies some p.projects & c.projects
	@Test
	public void testExtractionWithComplexExpression() {
		String expr = "p.(c.grades) implies some p.projects & c.projects";
		var expectedTerms = AlloyExpressionParsingUtils.findLeadingExpression(expr);
		assertThat(expectedTerms, is("p.(c.grades)"));
	}
}
