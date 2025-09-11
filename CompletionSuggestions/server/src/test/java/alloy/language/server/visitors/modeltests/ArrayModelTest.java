package alloy.language.server.visitors.modeltests;

import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.ArrayModel;
import alloy.language.server.visitors.BaseVisitorTest;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class ArrayModelTest extends BaseVisitorTest {
	private final CompletionModelBuilder modelBuilder = ArrayModel.modelBuilder();

	@Test
	public void testSigArrowToScalaType() {
		modelBuilder.withContent("one sig Array2 {").withCompletionLine("i2e: Int ->").withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		System.out.println("Completion Items: ");
		completionItems.stream()
		               .map(completionItem -> completionItem.getLabel() + " :: " + completionItem.getDetail())
		               .forEach(System.out::println);
		assertThat(completionItems, hasItems(hasProperty("label", is("Element"))));
	}

	@Test
	public void testQuantifierCompletion() {
		modelBuilder.withContent("fact f1 {").withCompletionLine("all idx: Array.").withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		System.out.println("Completion Items: ");
		completionItems.stream()
		               .map(completionItem -> completionItem.getLabel() + " :: " + completionItem.getDetail())
		               .forEach(System.out::println);
		assertThat(completionItems, hasItems(hasProperty("label", is("i2e"))));
	}

	@Test
	public void testQuantifierCompletion2() {
		modelBuilder.withContent("fact f1 {").withCompletionLine("all idx: Array.i2e.").withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		System.out.println("Completion Items: ");
		completionItems.stream()
		               .map(completionItem -> completionItem.getLabel() + " :: " + completionItem.getDetail())
		               .forEach(System.out::println);
		assertThat(completionItems, hasItems(hasProperty("label", is("Element"))));
	}
}
