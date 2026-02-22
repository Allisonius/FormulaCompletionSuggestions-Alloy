package alloy.language.server.visitors.modeltests;

import alloy.language.server.ConfigManager;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.ClassroomFolModel;
import alloy.language.server.models.presets.HandshakeModel;
import alloy.language.server.visitors.BaseVisitorTest;
import org.eclipse.lsp4j.CompletionItem;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.util.Comparator;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class ClassroomModelTest extends BaseVisitorTest {
	private final CompletionModelBuilder modelBuilder = ClassroomFolModel.modelBuilder();

	@BeforeAll
	public static void setup() {
		// Ensure that the new completion provider is enabled for testing
		ConfigManager.getInstance().setUseNewCompletionProvider(true);
	}

	@Test
	public void testCompletionForInOpsWithArrowedLeftHandSide() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all c:Class,p:Person | p in (c.Groups).Group implies Teaches.c -> p in")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		System.out.println("Completion Items: ");
		completionItems.stream()
		               .distinct()
		               .sorted(Comparator.comparing(CompletionItem::getSortText))
		               .map(completionItem -> completionItem.getLabel() + " :: " + completionItem.getDetail())
		               .forEach(System.out::println);
		assertThat(completionItems, hasItems(hasProperty("label", is("Tutors"))));
	}

	@Test
	public void testCompletionForQuantifiedParamWithOpenParenthesis() {
		modelBuilder.withContent("pred p1 {").withCompletionLine("all c:Class,s:Student | some s.(c.").withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		System.out.println("Completion Items: ");
		completionItems.stream()
		               .distinct()
		               .sorted(Comparator.comparing(CompletionItem::getSortText))
		               .map(completionItem -> completionItem.getLabel() + " :: " + completionItem.getDetail())
		               .forEach(System.out::println);
		assertThat(completionItems, hasItems(hasProperty("label", is("Groups"))));
	}

	@Test
	public void testCompletionForQuantifiedParamWithDot() {
		modelBuilder.withContent("pred p1 {").withCompletionLine("all x:Teacher | some x.Teaches.").withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("Groups"))));
	}

	@Test
	public void testCompletionForJoinedTerm() {
		modelBuilder.withContent("pred p1 {").withCompletionLine("all c:Class | some Teacher &").withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("Teaches.c"))));
	}

	@Test
	public void testCompletionForJoinedTermWithImplication() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all c:Class | some c.Groups implies some Teacher &")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("Teaches.c"))));
	}

	@Test
	public void testCompletionForJoinedTermWithImplicationAndDot() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all c:Class | some c.Groups implies some Teacher & Teaches.")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("c"))));
	}

	@Test
	public void testCompletionForJoinedTermWithImplicationAndDotAndArrow() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all c:Class,p:Person | p in (c.Groups).Group implies Teaches.")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("c"))));
	}

	// Tutors in
//	@Test
//	public void testCompletionForInOps() {
//		modelBuilder.withContent("pred p1 {")
//		            .withCompletionLine("Tutors in")
//		            .withContent("}");
//		var completionItems = generateCompletions(modelBuilder);
//		printCompletionItems(completionItems);
//		assertThat(completionItems, hasItems(hasProperty("label", is("Teacher -> Student"))));
//	}
}
