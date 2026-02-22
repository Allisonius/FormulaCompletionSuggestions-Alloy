package alloy.language.server.visitors.modeltests;

import alloy.language.server.ConfigManager;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.DiffModel;
import alloy.language.server.utils.AlloyInstanceUtils;
import alloy.language.server.visitors.BaseVisitorTest;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class DiffModelTest extends BaseVisitorTest {
	private final CompletionModelBuilder modelBuilder = DiffModel.modelBuilder();

	@BeforeAll
	public static void setup() {
		// Ensure that the new completion provider is enabled for testing
		ConfigManager.getInstance().setUseNewCompletionProvider(true);
	}

	@Test
	public void testDiffModelCompletion() {
		var world = AlloyInstanceUtils.buildAlloyModel(modelBuilder.build());
		String modelSize = AlloyInstanceUtils.modelSize(world);
		System.out.println("Model Size: " + modelSize);
	}

	// pred ObjAttrib[objs: set Obj, fName:one FName, fType: set { Obj +
	@Test
	public void testDiffModelCompletion2() {
		modelBuilder.withCompletionLine("pred ObjAttrib[objs: set Obj, fName:one FName, fType: set { Obj +");
		var completions = generateCompletions(modelBuilder);
		printCompletionItems(completions);
		assertThat(completions, not(empty()));
		assertThat(completions, hasItems(
				hasProperty("label", is("EnumVal")),
				hasProperty("label", is("Obj")),
				hasProperty("label", is("Val"))
		));
	}

	//objs.get[fName] in
	@Test
	public void testDiffModelCompletion3() {
		modelBuilder.withContent("pred ObjAttrib[objs: set Obj, fName:one FName, fType: set { Obj + Val + EnumVal }] {")
				.withCompletionLine("objs.get[fName] in ")
				.withContent("}");
		var completions = generateCompletions(modelBuilder);
		printCompletionItems(completions);
		assertThat(completions, not(empty()));
//		assertThat(completions, hasItems(
//				hasProperty("label", is("EnumVal")),
//				hasProperty("label", is("Obj")),
//				hasProperty("label", is("Val"))
//		));
	}
}
