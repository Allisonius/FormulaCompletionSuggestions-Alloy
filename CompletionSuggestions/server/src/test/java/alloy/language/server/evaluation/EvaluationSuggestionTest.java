package alloy.language.server.evaluation;

import alloy.language.server.alloyParser;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.ArrayModel;
import alloy.language.server.models.presets.ClassroomFolModel;
import alloy.language.server.utils.AlloyExpressionParsingUtils;
import alloy.language.server.utils.AlloyInstanceUtils;
import alloy.language.server.visitors.BaseVisitorTest;
import edu.mit.csail.sdg.parser.CompModule;
import org.junit.jupiter.api.Test;

import java.util.List;
import java.util.Map;

public class EvaluationSuggestionTest extends BaseVisitorTest {

	CompletionModelBuilder modelBuilder = ClassroomFolModel.modelBuilder();

	private alloyParser.ExprContext buildExpression(String expr) {
		CompletionModelBuilder modelBuilder = CompletionModelBuilder.modelBuilder();
		String model = modelBuilder.withCompletionLine(expr).build();

		alloyParser parser = buildParser(model);
		return parser.expr();
	}

	@Test
	public void testSuggestionEvaluation() {
		String model = modelBuilder.build();
		CompModule compModule = AlloyInstanceUtils.buildAlloyModel(model);

		List<String> suggestions = List.of("((Teacher).(Teaches))", "Teacher.Teaches", "Teacher", "t");
		String incompleteExpression = "all t: Teacher | Class in ";
		var tree = buildExpression(incompleteExpression);
		Map<String, alloyParser.ExprContext> quantifierMap =
				AlloyExpressionParsingUtils.getQuantifierMap(tree, Map.of());
		var evaluations = AlloyInstanceUtils.evaluateSuggestions(compModule, "Class in ", suggestions, "Teacher.Teaches", "Teacher.Teaches", "Teacher.Teaches",
				quantifierMap);
		for (var evaluation : evaluations.evaluations()) {
			System.out.println(evaluation);
		}
	}

	@Test
	public void testSuggestionWithArrayModel() {
		String model = ArrayModel.modelBuilder().build();
		CompModule compModule = AlloyInstanceUtils.buildAlloyModel(model);

		List<String> suggestions = List.of("Array.i2e", "Array", "idx", "Int", "Element", "length");
		String incompleteExpression = "all idx: Array.i2e.Element | idx >= 0 && idx < Array.";
		var tree = buildExpression(incompleteExpression);
		Map<String, alloyParser.ExprContext> quantifierMap =
				AlloyExpressionParsingUtils.getQuantifierMap(tree, Map.of());
		var evaluations = AlloyInstanceUtils.evaluateSuggestions(compModule,
				incompleteExpression,
				suggestions,
				"length", "length", "length",
				quantifierMap);
		for (var evaluation : evaluations.evaluations()) {
			System.out.println(evaluation);
		}
	}

	//Element = Array.
	@Test
	public void testSuggestionEvaluationWithElement() {
		String model = ArrayModel.modelBuilder().build();
		CompModule compModule = AlloyInstanceUtils.buildAlloyModel(model);

		List<String> suggestions = List.of("length", "i2e", "i2e.Element", "i2e + univ", "i2e & univ", "i2e.univ");
		String incompleteExpression = "Element = Array.";
		var tree = buildExpression(incompleteExpression);
		Map<String, alloyParser.ExprContext> quantifierMap =
				AlloyExpressionParsingUtils.getQuantifierMap(tree, Map.of());
		var evaluations = AlloyInstanceUtils.evaluateSuggestions(compModule,
				incompleteExpression,
				suggestions,
				"i2e[Int]", "i2e[Int]", "i2e[Int]",
				quantifierMap);
		for (var evaluation : evaluations.evaluations()) {
			System.out.println(evaluation);
		}
	}
}
