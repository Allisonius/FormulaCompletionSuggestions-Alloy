package alloy.language.server.utils;

import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.BinaryTreeModel;
import alloy.language.server.models.presets.CourseModel;
import alloy.language.server.suggestions.RelationalGraphSuggestions;
import alloy.language.server.utils.data.SuggestionTerm;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.util.Map;

class RelationalGraphSuggestionsTest {

	@Test
	void buildForwardSuggestions() {
		CompletionModelBuilder modelBuilder = CourseModel.modelBuilder();
		String model = modelBuilder.build();

		var world = AlloyInstanceUtils.buildAlloyModel(model);

		var firstSig = world.getAllSigs().get(0);
		//		var presetRelations = new ArrayList<>(
		//				List.of(new ModelGraph.RelationChain(firstSig.type(), CodeUtils.formatLabel(firstSig.label))));
		//		var forwardRelations = graph.findForwardRelations(firstSig.type(), 1, presetRelations);
		//		System.out.println("Relations found for: " + firstSig.label);
		//		System.out.println(forwardRelations);

		//		var classSig = world.getAllSigs().get(0);
		//		var reversePresetRelations = new ArrayList<ModelGraph.RelationChain>();
		//		var reverseRelations = graph.findReverseRelations(classSig.type(), 1, reversePresetRelations);
		//		System.out.println("Reverse relations found for: " + classSig.label);
		//		System.out.println(reverseRelations);

		RelationalGraphSuggestions graphSuggestions = new RelationalGraphSuggestions(world);
		var suggestions = graphSuggestions.buildForwardSuggestions(
				new SuggestionTerm(CodeUtils.formatLabel(firstSig.label), firstSig.type(), SuggestionTerm.Degree.SIG),
				Map.of());
		System.out.println("Suggestions for: " + firstSig.label);
		suggestions.forEach(System.out::println);
	}

	@Test
	public void testForwardSuggestionsBinaryTreeModel() {
		CompletionModelBuilder modelBuilder = BinaryTreeModel.modelBuilder();
		String model = modelBuilder.build();

		var world = AlloyInstanceUtils.buildAlloyModel(model);

		var firstSig = world.getAllSigs().get(0);
		RelationalGraphSuggestions graphSuggestions = new RelationalGraphSuggestions(world);
		var suggestions = graphSuggestions.buildForwardSuggestions(
				new SuggestionTerm(CodeUtils.formatLabel(firstSig.label), firstSig.type(), SuggestionTerm.Degree.SIG),
				Map.of());
		System.out.println("Suggestions for: " + firstSig.label);
		suggestions.forEach(System.out::println);
	}
}