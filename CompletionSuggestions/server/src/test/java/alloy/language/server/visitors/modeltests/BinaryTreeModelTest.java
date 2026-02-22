package alloy.language.server.visitors.modeltests;

import alloy.language.server.ConfigManager;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.BinaryTreeModel;
import alloy.language.server.visitors.BaseVisitorTest;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class BinaryTreeModelTest extends BaseVisitorTest {
	private final CompletionModelBuilder modelBuilder = BinaryTreeModel.modelBuilder();

	@BeforeAll
	public static void setup() {
		// Ensure that the new completion provider is enabled for testing
		ConfigManager.getInstance().setUseNewCompletionProvider(true);
	}

	@Test
	public void testLoneNodeDotOps() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all n : Node | lone n.")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);

		assertThat(completionItems, hasItems(hasProperty("label", is("left"))));
	}

	@Test
	public void testUnionInsideParenthesis() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all n : Node | n !in n.^(left +")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);

		assertThat(completionItems, hasItems(hasProperty("label", is("right"))));
	}

	@Test
	public void testUnionInsideParenthesis2() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all n : Node | lone n.~(left +")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);

		assertThat(completionItems, hasItems(hasProperty("label", is("right"))));
	}

	@Test
	public void testDotInsideParenthesis() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all n : Node | no n.")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);

		assertThat(completionItems, hasItems(hasProperty("label", is("left"))));
	}

	@Test
	public void testIntersectionInsideParenthesis() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all n : Node | no n.left &")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);

		assertThat(completionItems, hasItems(hasProperty("label", is("n.right"))));
	}

	@Test
	public void testDotInsideParenthesis2() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all n : Node | no n.left & n.")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);

		assertThat(completionItems, hasItems(hasProperty("label", is("right"))));
	}
}
