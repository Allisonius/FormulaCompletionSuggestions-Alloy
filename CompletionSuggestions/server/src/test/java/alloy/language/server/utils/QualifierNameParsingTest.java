package alloy.language.server.utils;

import alloy.language.server.alloyParser;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.visitors.BaseVisitorTest;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;

class QualifierNameParsingTest extends BaseVisitorTest {

	@Test
	public void testDotType() {
		CompletionModelBuilder modelBuilder = CompletionModelBuilder.modelBuilder();
		String model = modelBuilder.withCompletionLine("some Class ").build();
		alloyParser parser = buildParser(model);
		var tree = parser.expr();
		String qualName = AlloyExpressionParsingUtils.findQualifierName(tree);

		assertThat(qualName, is("Class"));
	}

	@Test
	public void testExtendedDotType() {
		CompletionModelBuilder modelBuilder = CompletionModelBuilder.modelBuilder();
		String model = modelBuilder.withCompletionLine("some Class.Student ").build();
		alloyParser parser = buildParser(model);
		var tree = parser.expr();
		String qualName = AlloyExpressionParsingUtils.findQualifierName(tree);

		assertThat(qualName, is("Class.Student"));
	}

	@Test
	public void testExtendedDotTypeWithLogicalOps() {
		CompletionModelBuilder modelBuilder = CompletionModelBuilder.modelBuilder();
		String model = modelBuilder.withCompletionLine("some Group + Class.Student ").build();
		alloyParser parser = buildParser(model);
		var tree = parser.expr();
		String qualName = AlloyExpressionParsingUtils.findQualifierName(tree);

		assertThat(qualName, is("Class.Student"));
	}

	@Test
	public void testExpressionWithOpeningParenthesis() {
		CompletionModelBuilder modelBuilder = CompletionModelBuilder.modelBuilder();
		String model = modelBuilder.withContent("some (Person ").buildWithoutCommand();
		System.out.println(model);
		alloyParser parser = buildParser(model);
		var tree = parser.expr();
		System.out.println(tree.getText());
		String qualName = AlloyExpressionParsingUtils.findQualifierName(tree);

		assertThat(qualName, is("Person"));
	}

	@Test
	public void testExpressionWithOpeningParenthesisAndCompoundExpression() {
		CompletionModelBuilder modelBuilder = CompletionModelBuilder.modelBuilder();
		String model = modelBuilder.withContent("some (Student.Class + Person ").buildWithoutCommand();
		System.out.println(model);
		alloyParser parser = buildParser(model);
		var tree = parser.expr();
		System.out.println(tree.getText());
		String qualName = AlloyExpressionParsingUtils.findQualifierName(tree);

		assertThat(qualName, is("Person"));
	}

	@Test
	public void testExpressionWithOpeningParenthesisAndJoinedExpression() {
		CompletionModelBuilder modelBuilder = CompletionModelBuilder.modelBuilder();
		String model = modelBuilder.withContent("some (Student.Class ").buildWithoutCommand();
		System.out.println(model);
		alloyParser parser = buildParser(model);
		var tree = parser.expr();
		System.out.println(tree.getText());
		String qualName = AlloyExpressionParsingUtils.findQualifierName(tree);

		assertThat(qualName, is("Student.Class"));
	}

	@Test
	public void testExpressionWithClosedParenthesis() {
		CompletionModelBuilder modelBuilder = CompletionModelBuilder.modelBuilder();
		String model = modelBuilder.withContent("no (Person.teaches.~teaches - Person)").buildWithoutCommand();
		System.out.println(model);
		alloyParser parser = buildParser(model);
		var tree = parser.expr();
		System.out.println(tree.getText());
		String qualName = AlloyExpressionParsingUtils.findQualifierName(tree);

		assertThat(qualName, is("(Person.teaches.~teaches-Person)"));
	}

	@Test
	public void testExpressionWithClosedParenthesisAndQuantifiers() {
		CompletionModelBuilder modelBuilder = CompletionModelBuilder.modelBuilder();
		String model = modelBuilder.withContent("all p: Person, t: Teacher | no (p.teaches.~teaches - Teacher)").buildWithoutCommand();
		System.out.println(model);
		alloyParser parser = buildParser(model);
		var tree = parser.expr();
		System.out.println(tree.getText());
		String qualName = AlloyExpressionParsingUtils.findQualifierName(tree);

		assertThat(qualName, is("(Person.teaches.~teaches-Teacher)"));
	}
}