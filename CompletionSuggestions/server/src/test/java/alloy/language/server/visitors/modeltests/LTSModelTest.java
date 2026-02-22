package alloy.language.server.visitors.modeltests;

import alloy.language.server.ConfigManager;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.LTSModel;
import alloy.language.server.visitors.BaseVisitorTest;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class LTSModelTest extends BaseVisitorTest {
	private static CompletionModelBuilder modelBuilder = LTSModel.modelBuilder();

	@BeforeAll
	public static void setup() {
		// Ensure that the new completion provider is enabled for testing
		ConfigManager.getInstance().setUseNewCompletionProvider(true);
	}

	// let ts = { s1,s2:State | some e:Event | s1->e->s2 in
	@Test
	public void testInOps() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("let ts = { s1,s2:State | some e:Event | s1->e->s2 in")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("trans"))));
	}

	// let ts = { s1,s2:State | some e:Event | s1->e->s2 in trans } | all s:Init.^ts | some i:Init | i in s.
	@Test
	public void testDotOpsInsideOpeningBraket() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine(
				            "let ts = { s1,s2:State | some e:Event | s1->e->s2 in trans } | all s:Init.^ts | some i:Init | i in s.")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("^ts"))));
	}

	// let ts = { s1,s2:State | some e:Event | s1->e->s2 in trans } | all s:State | some i:Init | s in
	@Test
	public void testDotOpsInsideOpeningBraket2() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine(
				            "let ts = { s1,s2:State | some e:Event | s1->e->s2 in trans } | all s:State | some i:Init | s in")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("i.^ts"))));
	}
}
