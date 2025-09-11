package alloy.language.server.visitors.modeltests;

import alloy.language.server.document.AlloyDocumentModel;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.CourseModel;
import alloy.language.server.visitors.BaseVisitorTest;
import org.eclipse.lsp4j.CompletionItem;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.util.Comparator;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class CourseModelTest extends BaseVisitorTest {

	private final CompletionModelBuilder modelBuilder = CourseModel.modelBuilder();
	private final AlloyDocumentModel documentModel = new AlloyDocumentModel("", modelBuilder.build());

	@Test
	public void testDotCompletion() {
		modelBuilder.withContent("pred p1 {").withCompletionLine("   all c: Course | some teaches.").withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
	}

	@Test
	public void testDotCompletion2() {
		modelBuilder.withContent("pred p1 {").withCompletionLine("   enrolled.").withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("Course"))));
	}

	@Test
	public void testInCompletion() {
		modelBuilder.withContent("pred p1 {").withCompletionLine("   enrolled in").withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("Student -> Course"))));

	}

	@Test
	public void testScopedProjectsRelation() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all p : Project | some (Person <: projects).")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("p"))));
		assertThat(completionItems, hasItems(hasProperty("label", is("Project"))));

	}

	@Test
	public void testTypeTransition() throws IOException {
		String model = modelBuilder.build();
		AlloyDocumentModel documentModel = new AlloyDocumentModel("", model);
		var world = documentModel.getModel();

		var expr = world.parseOneExpressionFromString("Course");
		System.out.println(expr.type());
	}

	@Test
	public void testInFormulaWithLeadingExpression() {
		modelBuilder.withContent("pred p1 {").withCompletionLine("all p : Person | p.projects in p.").withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("enrolled.projects"))));

	}

	@Test
	public void testBinaryOPsWithLeadingExpression2() {
		modelBuilder.withContent("pred p1[p: Person] {")
		            .withCompletionLine("all c: Course | lone p.projects &")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("c.projects"))));
	}

	@Test
	public void testDotJoinWithLeadingExpression2() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all p : Person, c: Course | lone p.projects & c.")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("projects"))));

	}

	@Test
	public void testDotJoinForMultipleQuantifierBlocks() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all p : Person | all c: Course | lone p.projects & c.")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("projects"))));

	}

	@Test
	public void testInFormulaWithLeadingExpression3() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all p : Person, c: Course | some p.projects.")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		//		assertThat(completionItems, hasItems(hasProperty("label", is("projects"))));

	}

	//	@Test
	//	public void testInFormulaWithIntermediateExpressionInMultilineBlock() {
	//		modelBuilder.withContent("pred p1 {")
	//		            .withCompletionLine("all p : Person, c: Course | some p.projects in c.")
	//		            .withContent("some Person")
	//		            .withContent("}");
	//		var completionItems = generateCompletions(documentModel, modelBuilder);
	//		System.out.println("Completion Items: ");
	//		completionItems.stream()
	//		               .distinct()
	//		               .sorted(Comparator.comparing(CompletionItem::getSortText))
	//		               .map(completionItem -> completionItem.getLabel() + " :: " + completionItem.getDetail())
	//		               .forEach(System.out::println);
	//		assertThat(completionItems, hasItems(hasProperty("label", is("projects"))));
	//	}

	@Test
	public void testInFormulaWithQuantifiers() {
		modelBuilder.withContent("pred p1 {").withCompletionLine("all p : Person | p.projects in ").withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("p.enrolled.projects"))));

	}

	@Test
	public void testInFormulaWithQuantifiersMidStep() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all p : Person | p.projects & Course.")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("enrolled.projects"))));

	}

	@Test
	public void testInFormulaWithQuantifiersAndScoping() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all c : Course | c.grades.Grade in ")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("enrolled.c"))));

	}

	@Test
	public void testCompletionInsideQuantifiers() {
		modelBuilder.withContent("pred p1 {").withCompletionLine("all c : Course, p : c.").withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("projects"))));
	}


	@Test
	public void testCompletionWithOpeningParenthesis() {
		modelBuilder.withContent("pred p1 {").withCompletionLine("all p : Person | no (p.").withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("teaches"))));
	}

	@Test
	public void testCompletionWithOpeningParenthesis2() {
		modelBuilder.withContent("pred p1 {").withCompletionLine("all p : Person | no (p.teaches.").withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("~teaches"))));
	}

	//	@Test
	//	public void testCompletionWithOpeningParenthesis2AfterIn() {
	//		modelBuilder.withContent("pred p1 {")
	//		            .withCompletionLine("all p : Person | no (p.teaches.~teachers - ")
	//		            .withContent("}");
	//		var completionItems = generateCompletions(modelBuilder);
	//		System.out.println("Completion Items: ");
	//		completionItems.stream()
	//		               .distinct()
	//		               .sorted(Comparator.comparing(CompletionItem::getSortText))
	//		               .map(completionItem -> completionItem.getLabel() + " :: " + completionItem.getDetail())
	//		               .forEach(System.out::println);
	//		assertThat(completionItems, hasItems(hasProperty("label", is("p"))));
	//	}

	@Test
	public void testCompletionWithOpeningParenthesisForTernaryRelation() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all p : Person, c : Course | lone p.(c.")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("grades"))));
	}

	@Test
	public void testCompletionForDisjoint() {
		modelBuilder.withContent("pred p1 {").withCompletionLine("all p: Person, disj x,y: p.").withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("projects"))));
	}

	@Test
	public void testCompletionWithClosedParenthesisAndDiffOps() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine(
				            "all p : Person, disj x,y : p.projects | no ((Person <: projects).x & (Person <: projects).y) -")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("p"))));
	}

	@Test
	public void testIncompleteQuantifiers() {
		modelBuilder.withContent("pred p1 {").withCompletionLine("all c : Course, p : teaches.").withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("projects"))));
		assertThat(completionItems, hasItems(hasProperty("label", is("grades"))));
	}

	@Test
	public void testQuantifierWithOne() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all p : Project | one (Course <: projects).")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("p"))));
		assertThat(completionItems, hasItems(hasProperty("label", is("Project"))));
	}

	@Test
	public void testOrderedArg() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all c : Course, p : c.projects, disj x,y : (Person <: projects).p | some c.grades[x] and some c.grades[y] implies c.grades[x] in c.grades[y].(prev +")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("iden"))));
	}

	//all p:Person-Student | no p.
	@Test
	public void testCompletionWithDisjoint() {
		modelBuilder.withContent("pred p1 {").withCompletionLine("all p: Person - Student | no p.").withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("projects"))));
	}

	//all p : Person | all c : Course | c in p.teaches => c not in
	@Test
	public void testCompletionWithDisjoint2() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all p : Person | all c : Course | c in p.teaches => c not in")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("p.enrolled"))));
	}

	//enrolled.
	@Test
	public void testCompletionWithDisjoint3() {
		modelBuilder.withContent("pred p1 {").withCompletionLine("enrolled.Course in").withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("Student"))));
	}

}
