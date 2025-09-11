package alloy.language.server.completion.generator;

import alloy.language.server.ConfigManager;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.ClassroomFolModel;
import alloy.language.server.visitors.BaseVisitorTest;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertTrue;


public class ClassroomFolModelTest extends BaseVisitorTest {
	private final CompletionModelBuilder modelBuilder = ClassroomFolModel.modelBuilder();

	//	@BeforeAll
//	public static void setConfig() {
//		ConfigManager.getInstance().setUseGeneratorCompletion(true);
//	}
	@Test
	public void testInOperator() {
		modelBuilder.withContent("pred p1 {")
				.withCompletionLine("Person in")
				.withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		boolean foundMatch = doesCompletionContainLabel(completionItems, "Student", "");
		assertTrue(foundMatch, "No completion item label matches expectedLabel using doesExpressionsMatch");
	}

	@Test
	public void testCompletionForInOps() {
		modelBuilder.withContent("pred p1 {")
				.withCompletionLine("Tutors in")
				.withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		boolean foundMatch = doesCompletionContainLabel(completionItems, "Teacher -> Student");
		assertTrue(foundMatch, "No completion item label matches expectedLabel using doesExpressionsMatch");
	}

	@Test
	public void testCompletionForInOps2() {
		modelBuilder.withContent("pred p1 {")
				.withCompletionLine("Class in")
				.withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		boolean foundMatch = doesCompletionContainLabel(completionItems, "Teacher.Teaches");
		assertTrue(foundMatch, "No completion item label matches expectedLabel using doesExpressionsMatch");
	}


	@Test
	public void testCompletionForInOpsWithArrowedLeftHandSide() {
		modelBuilder.withContent("pred p1 {")
				.withCompletionLine("all c:Class,p:Person | p in (c.Groups).Group implies Teaches.c -> p in")
				.withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		System.out.println("Completion Items: ");
		printCompletionItems(completionItems);
		boolean foundMatch = doesCompletionContainLabel(completionItems, "Tutors", "all c: Class,p:Person | some ");
		assertTrue(foundMatch, "No completion item label matches expectedLabel using doesExpressionsMatch");
	}

	@Test
	public void testCompletionForQuantifiedParamWithOpenParenthesis() {
		modelBuilder.withContent("pred p1 {").withCompletionLine("all c:Class,s:Student | some s.(c.").withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		System.out.println("Completion Items: ");
		printCompletionItems(completionItems);
		boolean foundMatch = doesCompletionContainLabel(completionItems, "Groups", "all c: Class,s: Student | some ");
		assertTrue(foundMatch, "No completion item label matches expectedLabel using doesExpressionsMatch");
	}

	@Test
	public void testCompletionForQuantifiedParamWithDot() {
		modelBuilder.withContent("pred p1 {").withCompletionLine("all x:Teacher | some x.Teaches.").withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		boolean foundMatch = doesCompletionContainLabel(completionItems, "Groups", "all x: Teacher | some ");
		assertTrue(foundMatch, "No completion item label matches expectedLabel using doesExpressionsMatch");
	}

	@Test
	public void testCompletionForJoinedTerm() {
		modelBuilder.withContent("pred p1 {").withCompletionLine("all c:Class | some Teacher &").withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		boolean foundMatch = doesCompletionContainLabel(completionItems, "Teaches.c", "all c: Class | some ");
		assertTrue(foundMatch, "No completion item label matches expectedLabel using doesExpressionsMatch");
	}

	@Test
	public void testCompletionForJoinedTermWithImplication() {
		modelBuilder.withContent("pred p1 {")
				.withCompletionLine("all c:Class | some c.Groups implies some Teacher &")
				.withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		boolean foundMatch = doesCompletionContainLabel(completionItems, "Teaches.c", "all c: Class | some ");
		assertTrue(foundMatch, "No completion item label matches expectedLabel using doesExpressionsMatch");
	}

	@Test
	public void testCompletionForJoinedTermWithImplicationAndDot() {
		modelBuilder.withContent("pred p1 {")
				.withCompletionLine("all c:Class | some c.Groups implies some Teacher & Teaches.")
				.withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		boolean foundMatch = doesCompletionContainLabel(completionItems, "c", "all c: Class | some ");
		assertTrue(foundMatch, "No completion item label matches expectedLabel using doesExpressionsMatch");
	}

	@Test
	public void testCompletionForJoinedTermWithImplicationAndDotAndArrow() {
		modelBuilder.withContent("pred p1 {")
				.withCompletionLine("all c:Class,p:Person | p in (c.Groups).Group implies Teaches.")
				.withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		boolean foundMatch = doesCompletionContainLabel(completionItems, "c", "all c: Class,p: Person | some ");
		assertTrue(foundMatch, "No completion item label matches expectedLabel using doesExpressionsMatch");
	}

	@Test
	public void testQuantifierItemInArrowCompletion() {
		modelBuilder.withContent("pred p1 {")
				.withCompletionLine("all t: Teacher | some c:Class | t ->")
				.withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		boolean foundMatch = doesCompletionContainLabel(completionItems, "c", "all t: Teacher | some c:Class | some ");
		assertTrue(foundMatch, "No completion item label matches expectedLabel using doesExpressionsMatch");
	}

	@Test
	public void testCompletionForBackwardsDotOps() {
		modelBuilder.withContent("pred p1 {")
				.withCompletionLine("all p : Person | some ^Tutors.p &")
				.withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		boolean foundMatch = doesCompletionContainLabel(completionItems, "Teacher", "all p: Person | some ");
		assertTrue(foundMatch, "No completion item label matches expectedLabel using doesExpressionsMatch");
	}

	@Test
	public void testCompletionForInOpsWithArrowedRightHandSide() {
		modelBuilder.withContent("pred p1 {")
				.withCompletionLine("all t: Teacher | some c:Class | t -> c in")
				.withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		boolean foundMatch = doesCompletionContainLabel(completionItems, "Teaches", "all t: Teacher | some c:Class | some ");
		assertTrue(foundMatch, "No completion item label matches expectedLabel using doesExpressionsMatch");
	}


	// Tutors in
//	@Test
//	public void testCompletionForInOps() {
//		modelBuilder.withContent("pred p1 {").withCompletionLine("Tutors in").withContent("}");
//		var completionItems = generateCompletions(modelBuilder);
//		printCompletionItems(completionItems);
//		boolean foundMatch = doesCompletionContainLabel(completionItems, "Teacher -> Student");
//		assertTrue(foundMatch, "No completion item label matches expectedLabel using doesExpressionsMatch");
//	}
}
