package alloy.language.server.visitors.modeltests;

import alloy.language.server.ConfigManager;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.ModeloAlloyModel;
import alloy.language.server.visitors.BaseVisitorTest;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class ModeloAlloyModelTest extends BaseVisitorTest {
	private final CompletionModelBuilder modelBuilder = ModeloAlloyModel.modelBuilder();

	@BeforeAll
	public static void setup() {
		// Ensure that the new completion provider is enabled for testing
		ConfigManager.getInstance().setUseNewCompletionProvider(true);
	}

	//pred oneAdPerProductPred{
	//  some p: Product | lone aP: ProductAd | p in aP.advertisedProduct
	//}
	@Test
	public void testWithPredicateCall() {
		modelBuilder.withContent("pred oneAdPerProductPred{")
				.withCompletionLine("some p: Product | lone aP: ProductAd | p in ")
				.withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, not(empty()));
		assertThat(completionItems, hasItems(hasProperty("label", is("aP.advertisedProduct"))));
	}

	//assert PetMaxThreePostsPerDateAssert {
	//  #NormalPost =4
	//
	//  //fechaActual.ValorDias = 100
	//  all m: Pet| all f: Date | #{ p: NormalPost | p in m.posts and p.publishedDate = f } =< 3
	//}

	@Test
	public void testWithAssertion() {
		modelBuilder.withContent("assert PetMaxThreePostsPerDateAssert {")
				.withCompletionLine("all m: Pet| all f: Date | #{ p: NormalPost | p in ")
				.withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, not(empty()));
		assertThat(completionItems, hasItems(hasProperty("label", is("m.posts"))));
	}

	//pred fivePetsOneOwner {
	//  one p: Owner | {
	//    all m: Pet | m in p.ownerOf and p in m.petOf
	//  }
	//}
	@Test
	public void testWithNestedQuantifiers() {
		modelBuilder.withContent("pred fivePetsOneOwner {")
				.withCompletionLine("one p: Owner | all m: Pet | m in p.")
				.withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, not(empty()));
		assertThat(completionItems, hasItems(hasProperty("label", is("ownerOf"))));
	}

	//fact eventSuspended{
	//
	//  all e: Event | (daysRemaining[e.eventDate] =< 7 and #{e.
	@Test
	public void testWithFact() {
		modelBuilder.withContent("fact eventSuspended{")
				.withCompletionLine("all e: Event | (daysRemaining[e.eventDate] =< 7 and #{e.")
				.withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, not(empty()));
		assertThat(completionItems, hasItems(hasProperty("label", is("participants"))));
	}
}
