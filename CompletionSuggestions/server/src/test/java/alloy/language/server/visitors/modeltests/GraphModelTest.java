package alloy.language.server.visitors.modeltests;

import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.ClassDiagramModel;
import alloy.language.server.models.presets.GraphModel;
import alloy.language.server.visitors.BaseVisitorTest;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class GraphModelTest extends BaseVisitorTest {
	private final CompletionModelBuilder modelBuilder = GraphModel.modelBuilder();

	@Test
	public void testDiffInQuantifier() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("no adj & ")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		System.out.println("Completion Items: ");
		completionItems.stream()
		               .map(completionItem -> completionItem.getLabel() + " :: " + completionItem.getDetail())
		               .forEach(System.out::println);
		assertThat(completionItems, hasItems(hasProperty("label", is("iden"))));
	}
}
