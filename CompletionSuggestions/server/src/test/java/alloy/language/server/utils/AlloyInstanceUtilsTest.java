package alloy.language.server.utils;

import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.*;
import edu.mit.csail.sdg.ast.Expr;
import org.junit.jupiter.api.Test;

import java.io.IOException;

class AlloyInstanceUtilsTest {

	@Test
	void getInstanceGraph() {
		CompletionModelBuilder modelBuilder = CourseModel.modelBuilder();
		String model = modelBuilder.build();
		var world = AlloyInstanceUtils.buildAlloyModel(model);
		var instance = AlloyInstanceUtils.buildInstance(world);
		System.out.println(instance);
		var graph = AlloyInstanceUtils.getInstanceGraph(world, instance);
		System.out.println(graph);
	}

	@Test
	void testTemporalInstance() {
		CompletionModelBuilder modelBuilder = TrashLTLModel.modelBuilder();
		String model = modelBuilder.build();
		var world = AlloyInstanceUtils.buildAlloyModel(model);
		var instance = AlloyInstanceUtils.buildInstance(world);
		System.out.println(instance);
		var graph = AlloyInstanceUtils.getInstanceGraph(world, instance);
		System.out.println(graph);
	}

	@Test
	void testTemporalInstance2() {
		CompletionModelBuilder modelBuilder = FerrymanModel.modelBuilder();
		String model = modelBuilder.build();
		var world = AlloyInstanceUtils.buildAlloyModel(model);
//		var instance = AlloyInstanceUtils.buildInstanceFromCommand(world, "Run moved");
		var instance = AlloyInstanceUtils.buildInstanceFromCommand(world, "Check sheepAlive");
		System.out.println(instance);
		var graph = AlloyInstanceUtils.getInstanceGraph(world, instance);
		System.out.println(graph);
	}

	@Test
	void testClassroomModel() {
		CompletionModelBuilder modelBuilder = ClassroomFolModel.modelBuilder();
		String model = modelBuilder.build();
		var world = AlloyInstanceUtils.buildAlloyModel(model);
		var instance = AlloyInstanceUtils.buildInstance(world);
		System.out.println(instance);
		var graph = AlloyInstanceUtils.getInstanceGraph(world, instance);
		System.out.println(graph);
	}

	@Test
	void testLegacyViz() throws IOException {
		CompletionModelBuilder modelBuilder = CourseModel.modelBuilder();
		String model = modelBuilder.build();
		var world = AlloyInstanceUtils.buildAlloyModel(model);
		var instance = AlloyInstanceUtils.buildInstance(world);
		var viz = AlloyInstanceUtils.showLegacyVisualizer(instance, "test.als");
		try {
			Thread.sleep(5000);
			viz.getFrame().invalidate();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}

	@Test
	public void testMatchSyntactically() {
		CompletionModelBuilder modelBuilder = ArrayModel.modelBuilder();
		String model = modelBuilder.build();
		var world = AlloyInstanceUtils.buildAlloyModel(model);
		var matches = AlloyInstanceUtils.matchesSyntactically(world, "all idx: Array.i2e.Element | some length", "all idx: Array.i2e.Element | some length");
		System.out.println("Matches: " + matches);
	}

	@Test
	public void testMatchSemantically() {
		CompletionModelBuilder modelBuilder = ArrayModel.modelBuilder();
		String model = modelBuilder.build();
		var world = AlloyInstanceUtils.buildAlloyModel(model);
		Expr fact = world.getAllFacts().makeConstList().stream().map(f -> f.b).reduce(Expr::and).orElse(null);
		var matches = AlloyInstanceUtils.matchesFormula(world,
				"all idx: Array.i2e.Element | idx >= 0 && idx < Array.length",
				"all idx: Array.i2e.Element | idx >= 0 && idx < Array.i2e.Element",
				fact);
		System.out.println("Matches: " + matches);
	}
}