package alloy.language.server.visitors.modeltests;

import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.SocialMediaModel;
import alloy.language.server.visitors.BaseVisitorTest;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class SocialMediaModelTest extends BaseVisitorTest {
	private final CompletionModelBuilder modelBuilder = SocialMediaModel.modelBuilder();

	@Test
	public void testInOps() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all i : Influencer, d : Day| d in ")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("i.posts.date"))));
	}

	@Test
	public void testDotOps() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all i:Influencer, d:Day| d in i.posts.")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("date"))));
	}

	@Test
	public void testDiffOps() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all p : User | p.sees - ")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("Ad"))));
	}

	@Test
	public void testDiffOps2() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all p : User | p.sees - Ad in")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		System.out.println(completionItems.size());
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("p.follows.posts"))));
	}

	@Test
	public void testEqualityOps() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all i : Influencer | follows.i = User - ")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("i"))));
	}

	@Test
	public void testImpliesOps() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all a : Ad, u : User | a in u.sees => a in u.follows.posts or a in ")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("u.suggested.posts"))));
	}

	// all u: User | some u.posts & Ad => u.posts in
	@Test
	public void testAndOps() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all u: User | some u.posts & Ad => u.posts in ")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("Ad"))));
	}

	// all p : User | p.sees - Ad in p.follows.
	@Test
	public void testMinusOps() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all p : User | p.sees - Ad in p.follows.")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("posts"))));
	}
}
