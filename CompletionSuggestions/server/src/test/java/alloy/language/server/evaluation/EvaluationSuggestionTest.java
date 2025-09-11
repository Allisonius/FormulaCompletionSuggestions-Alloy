package alloy.language.server.evaluation;

import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.ArrayModel;
import alloy.language.server.models.presets.ClassroomFolModel;
import alloy.language.server.utils.AlloyInstanceUtils;
import edu.mit.csail.sdg.parser.CompModule;
import org.junit.jupiter.api.Test;

import java.util.List;
import java.util.Map;

public class EvaluationSuggestionTest {

	CompletionModelBuilder modelBuilder = ClassroomFolModel.modelBuilder();

	@Test
	public void testSuggestionEvaluation() {
		String model = modelBuilder.build();
		CompModule compModule = AlloyInstanceUtils.buildAlloyModel(model);

		List<String> suggestions = List.of("((Teacher).(Teaches))", "Teacher.Teaches", "Teacher", "t");
		var evaluations = AlloyInstanceUtils.evaluateSuggestions(compModule, "Class in ", suggestions, "Teacher.Teaches", "Teacher.Teaches", "Teacher.Teaches",
				Map.of());
		System.out.println(evaluations.evaluations());
	}

	@Test
	public void testSuggestionWithArrayModel() {
		String model = ArrayModel.modelBuilder().build();
		CompModule compModule = AlloyInstanceUtils.buildAlloyModel(model);

		List<String> suggestions = List.of("Array.i2e", "Array", "a", "Int", "Element", "length");
		var evaluations = AlloyInstanceUtils.evaluateSuggestions(compModule,
				"all idx: Array.i2e.Element | idx >= 0 && idx < Array.",
				suggestions,
				"length", "length", "length",
				Map.of());
		System.out.println(evaluations.evaluations());
	}
}
