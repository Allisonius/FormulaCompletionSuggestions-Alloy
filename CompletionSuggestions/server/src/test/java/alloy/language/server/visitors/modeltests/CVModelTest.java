package alloy.language.server.visitors.modeltests;

import alloy.language.server.ConfigManager;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.CVModel;
import alloy.language.server.visitors.BaseVisitorTest;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class CVModelTest extends BaseVisitorTest {
	private final CompletionModelBuilder modelBuilder = CVModel.modelBuilder();

	@BeforeAll
	public static void setup() {
		// Ensure that the new completion provider is enabled for testing
		ConfigManager.getInstance().setUseNewCompletionProvider(true);
	}

	@Test
	public void testSimpleQuantifiedCompletion() {
		modelBuilder.withContent("pred p1 {").withCompletionLine("all u : User | u.").withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		System.out.println("Completion Items: ");
		completionItems.stream()
		               .map(completionItem -> completionItem.getLabel() + " :: " + completionItem.getDetail())
		               .forEach(System.out::println);
		assertThat(completionItems, hasItems(hasProperty("label", is("visible")), hasProperty("label", is("profile"))));
	}

	@Test
	public void testQuantifiedFormulaWithParenthesis() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all u : User, disj x,y : u.profile | x.source = y.source implies no (x.")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		System.out.println("Completion Items: ");
		completionItems.stream()
		               .map(completionItem -> completionItem.getLabel() + " :: " + completionItem.getDetail())
		               .forEach(System.out::println);
		assertThat(completionItems, hasItems(hasProperty("label", is("ids"))));
	}

	@Test
	public void testQuantifiedFormulaWithOpeningParenthesisAndIntersectionOp() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all u : User, disj x,y : u.profile | x.source = y.source implies no (x.ids & ")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		System.out.println("Completion Items: ");
		completionItems.stream()
		               .map(completionItem -> completionItem.getLabel() + " :: " + completionItem.getDetail())
		               .forEach(System.out::println);
		assertThat(completionItems, hasItems(hasProperty("label", is("y.ids"))));
	}

	@Test
	public void testQuantifiedFormulaWithOpeningParenthesisAndIntersectionOpWithDotOp() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all u : User, disj x,y : u.profile | x.source = y.source implies no (x.ids & y.")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		System.out.println("Completion Items: ");
		completionItems.stream()
		               .map(completionItem -> completionItem.getLabel() + " :: " + completionItem.getDetail())
		               .forEach(System.out::println);
		assertThat(completionItems, hasItems(hasProperty("label", is("ids"))));
	}
}
