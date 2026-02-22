package alloy.language.server.visitors.modeltests;

import alloy.language.server.ConfigManager;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.ClassDiagramModel;
import alloy.language.server.models.presets.HandshakeModel;
import alloy.language.server.visitors.BaseVisitorTest;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class HandshakeModelTest extends BaseVisitorTest {
	private final CompletionModelBuilder modelBuilder = HandshakeModel.modelBuilder();

	@BeforeAll
	public static void setup() {
		// Ensure that the new completion provider is enabled for testing
		ConfigManager.getInstance().setUseNewCompletionProvider(true);
	}

	@Test
	public void testDiffInQuantifier() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all p,q: Person - ")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("Jocelyn"))));
	}

	// all p, q: Person | p!=q => | p.spouse = q => q.
	@Test
	public void testEqualityOps() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all p, q: Person | p!=q => p.spouse = q => q.")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("spouse"))));
	}

	// all p,q: Person - Jocelyn | p!=q => #p.
	@Test
	public void testDiffInQuantifierWithMinus() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all p,q: Person - Jocelyn | p!=q => #p.")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("shaken"))));
	}
}
