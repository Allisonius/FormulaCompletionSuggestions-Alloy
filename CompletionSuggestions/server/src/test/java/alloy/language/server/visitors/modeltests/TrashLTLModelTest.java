package alloy.language.server.visitors.modeltests;

import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.GraphModel;
import alloy.language.server.models.presets.TrashLTLModel;
import alloy.language.server.visitors.BaseVisitorTest;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class TrashLTLModelTest extends BaseVisitorTest {
	private final CompletionModelBuilder modelBuilder = TrashLTLModel.modelBuilder();

	@Test
	public void testVariableSigInSuggestion() {
		modelBuilder.withContent("pred p1 {").withCompletionLine("always Trash in").withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("Trash'"))));
	}

	@Test
	public void testInOperatorForSameType() {
		modelBuilder.withContent("pred p1 {").withCompletionLine("eventually ( some f: Trash | always f in ").withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("Trash"))));
	}

	@Test
	public void testWithTemporalUnOpsAndQuantifier() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("always all f : Protected | f in Trash releases f in")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("Protected'"))));
	}

	@Test
	public void testWithTemporalUnOpsAndQuantifiersInsideParenthesis() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("eventually ( some f: File | f not in")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("File'"))));
	}

	@Test
	public void testWithTemporalUnOpsAndQuantifiersInsideParenthesis2() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("always ( some f: File | f -")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("Protected"))));
	}

	@Test
	public void testWithDotOps() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("no link.")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("link"))));
	}
}
