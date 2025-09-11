package alloy.language.server.suggestions;

import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.CourseModel;
import alloy.language.server.utils.AlloyInstanceUtils;
import alloy.language.server.utils.CodeUtils;
import alloy.language.server.utils.data.SuggestionTerm;
import edu.mit.csail.sdg.parser.CompModule;
import org.junit.jupiter.api.Test;

import java.util.stream.Collectors;
import java.util.stream.Stream;

class LinearModelGraphTest {

	@Test
	public void testFindForwardRelations() {
		CompletionModelBuilder builder = CourseModel.modelBuilder();
		CompModule model = AlloyInstanceUtils.buildAlloyModel(builder.build());

		LinearModelGraph graph = new LinearModelGraph(model);

		var staticSuggestions = new StaticSuggestionsPool(model);

		var firstSig = model.getAllSigs().get(0);
		var firstField = firstSig.getFields().get(0);

		var suggestionTerm = new SuggestionTerm(firstSig.label, firstSig.type(), SuggestionTerm.Degree.SIG);

		var forwardRelations = graph.findForwardChain(suggestionTerm, 2, staticSuggestions.fromSignatures());
		System.out.println("Relations found for: " + firstSig.label);
		forwardRelations.forEach(System.out::println);
	}

	@Test
	public void testFindForwardRelationsWithDestination() {
		CompletionModelBuilder builder = CourseModel.modelBuilder();
		CompModule model = AlloyInstanceUtils.buildAlloyModel(builder.build());

		LinearModelGraph graph = new LinearModelGraph(model);

		var staticSuggestions = new StaticSuggestionsPool(model);

		var firstSig = model.getAllSigs().get(0);
		var secondSig = model.getAllSigs().get(4);

		var suggestionTerm = new SuggestionTerm(CodeUtils.formatLabel(firstSig.label), firstSig.type(), SuggestionTerm.Degree.SIG);

		var forwardRelations = Stream.of(1, 2)
		                             .flatMap(n -> graph.findForwardChainForDestinationType(suggestionTerm, "", n, secondSig.type(), staticSuggestions.fromSignatures()).stream()).collect(
				Collectors.toList());
		System.out.println("Relations found for: " + firstSig.label + " to " + secondSig.label);
		forwardRelations.forEach(System.out::println);
	}
}