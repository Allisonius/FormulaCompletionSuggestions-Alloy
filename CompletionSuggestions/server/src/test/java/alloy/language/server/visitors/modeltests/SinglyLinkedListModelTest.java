package alloy.language.server.visitors.modeltests;

import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.SinglyLinkedListModel;
import alloy.language.server.visitors.BaseVisitorTest;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class SinglyLinkedListModelTest extends BaseVisitorTest {
	private final CompletionModelBuilder modelBuilder = SinglyLinkedListModel.modelBuilder();

	@Test
	public void testChildQuantifier() {
		modelBuilder.withContent("pred p1 (l: List){")
		            .withCompletionLine("no l.header or some n: l.header.*link | no n.")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		System.out.println("Completion Items: ");
		completionItems.stream()
		               .map(completionItem -> completionItem.getLabel() + " :: " + completionItem.getDetail())
		               .forEach(System.out::println);
		assertThat(completionItems, hasItems(hasProperty("label", is("link"))));
	}


	@Test
	public void testChildIncompleteQuantifier() {
		modelBuilder.withContent("pred p1 (l: List){")
		            .withCompletionLine("no l.header or some n: l.header.")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		System.out.println("Completion Items: ");
		completionItems.stream()
		               .map(completionItem -> completionItem.getLabel() + " :: " + completionItem.getDetail())
		               .forEach(System.out::println);
		assertThat(completionItems, hasItems(hasProperty("label", is("*link"))));
	}
}
