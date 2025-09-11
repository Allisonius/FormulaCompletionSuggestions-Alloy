package alloy.language.server.visitors.modeltests;

import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.ProductionLineModel;
import alloy.language.server.models.presets.ProductionLineV2Model;
import alloy.language.server.visitors.BaseVisitorTest;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class ProductionLineModelV2Test extends BaseVisitorTest {
	private final CompletionModelBuilder modelBuilder = ProductionLineV2Model.modelBuilder();

	@Test
	public void testIntersectionOps() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all c : Component & Dangerous | no c.workstation.")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("workers"))));
	}
}
