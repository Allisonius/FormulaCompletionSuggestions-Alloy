package alloy.language.server.visitors.modeltests;

import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.TrainStationLTLModel;
import alloy.language.server.visitors.BaseVisitorTest;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class TrainStationLTLTest extends BaseVisitorTest {
	private final CompletionModelBuilder modelBuilder = TrainStationLTLModel.modelBuilder();

	@Test
	public void testDotOps() {
		modelBuilder.withContent("pred p1 {").withCompletionLine("no t : Track | t in t.").withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("^prox"))));
	}
}
