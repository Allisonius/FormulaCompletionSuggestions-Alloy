package alloy.language.server.utils;


import alloy.language.server.models.presets.ClassroomFolModel;
import edu.mit.csail.sdg.ast.Command;
import edu.mit.csail.sdg.ast.Expr;
import edu.mit.csail.sdg.parser.CompModule;
import edu.mit.csail.sdg.parser.CompUtil;
import edu.mit.csail.sdg.translator.A4Solution;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.io.IOException;

class AlloyEvaluationTest {

	private static AlloyEvaluation alloyEvaluation;

	@BeforeAll
	public static void setup() {
		String alloyCode = ClassroomFolModel.modelBuilder()
		                                    .build();
		CompModule world = CompUtil.parseEverything_fromString(null, alloyCode);
		A4Solution instance = AlloyInstanceUtils.buildInstance(world);
		alloyEvaluation = new AlloyEvaluation(world, instance);
	}

	@Test
	void testGetAllSigs() {
		System.out.println(alloyEvaluation.getAllSigs());
	}

	@Test
	void testGetAllSigsAsSuggestions() {
		var suggestions = alloyEvaluation.getAllSigsAsSuggestions();
		suggestions.forEach(System.out::println);
	}

	@Test
	void testAllAtoms() {
		System.out.println(alloyEvaluation.getAllAtoms());
	}

	@Test
	void testDotEval() {
		CompModule world = alloyEvaluation.getWorld();
		A4Solution instance = alloyEvaluation.getInstance();
		String incomplete = "all t: Teacher | some t.";
		for (var key : alloyEvaluation.getApplicableSuggestions()) {
			String complete = incomplete + key;
			System.out.println("Evaluating: " + complete);
			try {
				Expr expr = world.parseOneExpressionFromString(complete);
				var result = instance.eval(expr);
				System.out.println(result.getClass());
				System.out.println(result);
			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
		}
	}

	@Test
	void testAlloyInstanceOutput() {
		var instance = alloyEvaluation.getInstance();
		System.out.println(instance);
		var nextInstance = instance.next();
		System.out.println(nextInstance);
		System.out.println(instance.getAllAtoms());
		System.out.println(instance.getAllReachableSigs());
		for (var sig : instance.getAllReachableSigs()) {
			var fields = sig.getFields();
			if (fields.size() > 0) {
				System.out.println(fields.get(0)
				                         .getSubnodes());
			}
		}
	}

	@Test
	void testAddedLines() throws IOException {
		var instance = alloyEvaluation.getInstance();
		var world = alloyEvaluation.getWorld();
		var predExpr = world.parseOneExpressionFromString(
				"no Teacher & Student");
		System.out.println(predExpr);
		var commands = world.getAllCommands();
		System.out.println(commands);
//		var diffInstance = instance.eval(predExpr);
//		System.out.println(diffInstance);
	}
}