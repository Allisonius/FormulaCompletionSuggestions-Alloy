package alloy.language.server.visitors.modeltests;

import alloy.language.server.ConfigManager;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.CTree;
import alloy.language.server.visitors.BaseVisitorTest;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class CTreeModelTest extends BaseVisitorTest {
	private final CompletionModelBuilder modelBuilder = CTree.modelBuilder();

	@BeforeAll
	public static void setUp() {
//		ConfigManager.getInstance().setUseGeneratorCompletion(true);
	}

	//all n1: Node | all n2: Node-n1 | n1 in n2.
	@Test
	public void testDotOps() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all n1: Node | all n2: Node-n1 | n1 in n2.")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("^neighbors"))));
	}

	// no iden &
	@Test
	public void testNoIden() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("no iden &")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		System.out.println(completionItems.size());
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItem(hasProperty("label", is("neighbors"))));
	}
}
