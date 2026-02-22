package alloy.language.server.visitors.modeltests;

import alloy.language.server.ConfigManager;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.Checkmate;
import alloy.language.server.utils.AlloyInstanceUtils;
import alloy.language.server.visitors.BaseVisitorTest;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class CheckmateModelTest extends BaseVisitorTest {
	private final CompletionModelBuilder modelBuilder = Checkmate.modelBuilder();

	@BeforeAll
	public static void setup() {
		// Ensure that the new completion provider is enabled for testing
		ConfigManager.getInstance().setUseNewCompletionProvider(true);
	}

	@Test
	public void testModelSize() {
		String model = modelBuilder.build();
		var world = AlloyInstanceUtils.buildAlloyModel(model);
		String modelSize = AlloyInstanceUtils.modelSize(world);
		System.out.println("Model Size: " + modelSize);
	}

	//fact po_prior { all e: Event | lone e.
	@Test
	public void testPoPriorCompletion() {
		modelBuilder.withCompletionLine("fact po_prior { all e: Event | lone e.");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("~po"))));
	}

	//fun po_loc : MemoryEvent->MemoryEvent { ^po & (address.
	@Test
	public void testPoPriorDisjoint5() {
		modelBuilder.withCompletionLine("fun po_loc : MemoryEvent->MemoryEvent { ^po & (address.");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("map"))));
	}
}
