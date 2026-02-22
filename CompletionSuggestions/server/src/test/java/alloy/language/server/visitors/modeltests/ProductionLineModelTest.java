package alloy.language.server.visitors.modeltests;

import alloy.language.server.ConfigManager;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.ProductionLineModel;
import alloy.language.server.visitors.BaseVisitorTest;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class ProductionLineModelTest extends BaseVisitorTest {
	private final CompletionModelBuilder modelBuilder = ProductionLineModel.modelBuilder();

	@BeforeAll
	public static void setup() {
		// Ensure that the new completion provider is enabled for testing
		ConfigManager.getInstance().setUseNewCompletionProvider(true);
	}

	@Test
	public void testDotOpsWithQuant() {
		modelBuilder.withContent("pred p1 {")
				.withCompletionLine("all c : Component | some c.")
				.withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("parts"))));
	}


	@Test
	public void testIntersectionOps() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all c : Component | some (Robot <: position).(c.position) & ")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("Robot"))));
	}

	@Test
	public void testIntersectionOpsInsideQuantifiers() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all c : Component, p : c.parts & ")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("Component"))));
	}

	// all c : Component | c not in c.
	@Test
	public void testDotOps() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all c : Component | c not in c.")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("^parts"))));
	}

	// all c : Component, p : c.parts & Component | lte[p.
	@Test
	public void testDotOpsInsideOpeningBraket() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all c : Component, p : c.parts & Component | lte[p.")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("position"))));
	}

}
