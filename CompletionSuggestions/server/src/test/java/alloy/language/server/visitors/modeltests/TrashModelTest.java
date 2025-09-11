package alloy.language.server.visitors.modeltests;

import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.TrashModel;
import alloy.language.server.visitors.BaseVisitorTest;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class TrashModelTest extends BaseVisitorTest {
	private final CompletionModelBuilder modelBuilder = TrashModel.modelBuilder();

	@Test
	public void testVariableSigInSuggestion() {
		modelBuilder.withContent("pred p1 {").withCompletionLine("no link.").withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("link'"))));
	}
}
