package alloy.language.server.visitors.modeltests;

import alloy.language.server.ConfigManager;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.BemplModel;
import alloy.language.server.models.presets.ClassDiagramModel;
import alloy.language.server.visitors.BaseVisitorTest;
import org.eclipse.lsp4j.CompletionItem;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.util.Comparator;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class BemplModelTest extends BaseVisitorTest {
	private final CompletionModelBuilder modelBuilder = BemplModel.modelBuilder();

	@BeforeAll
	public static void setup() {
		// Ensure that the new completion provider is enabled for testing
		ConfigManager.getInstance().setUseNewCompletionProvider(true);
	}

	@Test
	public void testWithPredicateCall() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("all p : Person | CanEnter[p, secure_lab] implies p in")
		            .withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		System.out.println("Completion Items: ");
		completionItems.stream()
		               .map(completionItem -> completionItem.getLabel() + " :: " + completionItem.getDetail())
		               .forEach(System.out::println);
//		assertThat(completionItems, hasItems(hasProperty("label", is("Researcher"))));
	}
}
