package alloy.language.server.visitors.modeltests;

import alloy.language.server.ConfigManager;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.CTree;
import alloy.language.server.models.presets.JavaMetaModel;
import alloy.language.server.visitors.BaseVisitorTest;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class JavaMetaModelTest extends BaseVisitorTest {
	private final CompletionModelBuilder modelBuilder = JavaMetaModel.modelBuilder();

	@BeforeAll
	public static void setup() {
		// Ensure that the new completion provider is enabled for testing
		ConfigManager.getInstance().setUseNewCompletionProvider(true);
	}

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

	//pred noClassContainsTwoMethodsWithSameSignature {
	//	all c: Class | all m1,m2:c.methods | m1!=m2 =>(m1.id != m2.id or m1.param != m2.param)
	//}
	@Test
	public void testMethodSignature() {
		modelBuilder.withContent("pred noClassContainsTwoMethodsWithSameSignature {")
				.withCompletionLine("all c: Class | all m1,m2:c.methods | m1!=m2 =>(m1.")
				.withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		System.out.println(completionItems.size());
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItem(hasProperty("label", is("id"))));
	}

	//pred p1 {
	//all mi:MethodInvocation | (mi.q = qthis_) => some c1:Class, m1,m2:c1.
	// }
	@Test
	public void testMethodInvocation() {
		modelBuilder.withContent("pred p1 {")
				.withCompletionLine("all mi:MethodInvocation | (mi.q = qthis_) => some c1:Class, m1,m2:c1.")
				.withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		System.out.println(completionItems.size());
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItem(hasProperty("label", is("methods"))));
	}

	// pred p1 {
	//all mi:MethodInvocation | some c1,c2: Class, m1:c1.
	//}
	@Test
	public void testMethodInvocation2() {
		modelBuilder.withContent("pred p1 {")
				.withCompletionLine("all mi:MethodInvocation | some c1,c2: Class, m1:c1.")
				.withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItem(hasProperty("label", is("methods"))));
	}
}
