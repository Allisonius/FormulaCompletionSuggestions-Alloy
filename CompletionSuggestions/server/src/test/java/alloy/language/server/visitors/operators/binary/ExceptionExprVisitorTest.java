package alloy.language.server.visitors.operators.binary;

import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.ClassroomFolModel;
import alloy.language.server.visitors.BaseVisitorTest;
import alloy.language.server.visitors.completions.operators.ExceptionExpVisitor;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

class ExceptionExprVisitorTest extends BaseVisitorTest {

	@Test
	public void test() {
		CompletionModelBuilder modelBuilder = ClassroomFolModel.modelBuilder();
		modelBuilder = modelBuilder.withContent("pred abc {").withCompletionLine("some Class. ").withContent("}");

		var completionItems = generateCompletionForVisitor(modelBuilder, ExceptionExpVisitor.class);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("Groups"))));
	}

	@Test
	public void testWithQuantifiers() {
		CompletionModelBuilder modelBuilder = ClassroomFolModel.modelBuilder();
		modelBuilder = modelBuilder.withContent("pred abc {")
		                           .withCompletionLine("some p: Person | some Tutors. ")
		                           .withContent("}");
		var completionItems = generateCompletionForVisitor(modelBuilder, ExceptionExpVisitor.class);
		printCompletionItems(completionItems);

		assertThat(completionItems, hasItem(hasProperty("label", is("p"))));
	}

	@Test
	public void testWithQuantifiersInQualifier() {
		CompletionModelBuilder modelBuilder = ClassroomFolModel.modelBuilder();
		modelBuilder = modelBuilder.withContent("pred abc {")
		                           .withCompletionLine("some p: Person | some p. ")
		                           .withContent("}");
		var completionItems = generateCompletionForVisitor(modelBuilder, ExceptionExpVisitor.class);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItem(hasProperty("label", is("Tutors"))));
		assertThat(completionItems, hasItem(hasProperty("label", is("Teaches"))));
	}

	@Test
	public void testDotParseTree() {
		CompletionModelBuilder modelBuilder = ClassroomFolModel.modelBuilder();
		modelBuilder = modelBuilder.withContent("pred abc {")
		                           .withCompletionLine("some Class.Groups and no Class.Groups. ")
		                           .withContent("}");
		var completionItems = generateCompletionForVisitor(modelBuilder, ExceptionExpVisitor.class);
		printCompletionItems(completionItems);

		assertThat(completionItems, hasItems(hasProperty("label", is("Group"))));
	}

	@Test
	public void testDotForParenthesis() {
		CompletionModelBuilder modelBuilder = ClassroomFolModel.modelBuilder();
		modelBuilder = modelBuilder.withContent("pred abc {")
		                           .withCompletionLine("let a = { some Class.Groups. ")
		                           .withContent("}");
		var completionItems = generateCompletionForVisitor(modelBuilder, ExceptionExpVisitor.class);
		printCompletionItems(completionItems);

		assertThat(completionItems, hasItems(hasProperty("label", is("Group"))));
	}

	@Test
	public void testDotForParenthesisWithLet() {
		CompletionModelBuilder modelBuilder = ClassroomFolModel.modelBuilder();
		modelBuilder = modelBuilder.withContent("pred abc {")
		                           .withCompletionLine("let ts = { s1, s2:Class | some e:Person | s1->e->s2 in")
		                           .withContent("}");
		var completionItems = generateCompletionForVisitor(modelBuilder, ExceptionExpVisitor.class);
		printCompletionItems(completionItems);

		assertThat(completionItems, hasItems(hasProperty("label", is("Group"))));
	}

	@Test
	public void testDotForParenthesisClosedWithLet() {
		CompletionModelBuilder modelBuilder = ClassroomFolModel.modelBuilder();
		modelBuilder = modelBuilder.withContent("pred abc {")
		                           .withCompletionLine("let ts = { s1,s2:State | some e:Event | s1->e->s2 in trans } | all s:Init.^ts | some i:Init | i in s.")
		                           .withContent("}");
		var completionItems = generateCompletionForVisitor(modelBuilder, ExceptionExpVisitor.class);
		printCompletionItems(completionItems);

		assertThat(completionItems, hasItems(hasProperty("label", is("Group"))));
	}
}