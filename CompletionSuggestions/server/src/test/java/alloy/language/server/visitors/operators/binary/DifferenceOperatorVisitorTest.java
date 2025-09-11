package alloy.language.server.visitors.operators.binary;

import alloy.language.server.alloyParser;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.ClassroomFolModel;
import alloy.language.server.utils.AlloyEvaluation;
import alloy.language.server.visitors.completions.AbstractCompletionVisitors;
import alloy.language.server.visitors.BaseVisitorTest;
import alloy.language.server.visitors.extractors.QuantifierExtractorVisitor;
import alloy.language.server.visitors.completions.operators.set.DifferenceOperatorVisitor;
import org.eclipse.lsp4j.CompletionItem;
import org.eclipse.lsp4j.CompletionParams;
import org.junit.jupiter.api.Test;

import java.util.Comparator;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

class DifferenceOperatorVisitorTest extends BaseVisitorTest {
	@Test
	public void testSingleTerm() {
		CompletionModelBuilder modelBuilder = ClassroomFolModel.modelBuilder();
		String model = modelBuilder.withContent("pred abc {")
		                           .withCompletionLine("some Teacher - ")
		                           .withContent("}")
		                           .build();
		alloyParser parser = buildParser(model);
		System.out.println(model);
		CompletionParams completionParams = buildCompletionParams(modelBuilder);
		var tree = parser.alloyModule();
		AlloyEvaluation alloyEvaluation = buildAlloyEvaluation(model, completionParams);

		var quantifiers = new QuantifierExtractorVisitor(model, completionParams).visit(tree);

		AbstractCompletionVisitors visitor = new DifferenceOperatorVisitor(model, completionParams, alloyEvaluation, quantifiers);
		var completionItems = visitor.visit(tree);
		System.out.println(completionItems);
		assertThat(completionItems,
		           containsInAnyOrder(hasProperty("label", is("Person")), hasProperty("label", is("Student")),
		                              hasProperty("label", is("Group")), hasProperty("label", is("Class"))));

	}

	@Test
	public void testMultiArityTerm() {
		CompletionModelBuilder modelBuilder = ClassroomFolModel.modelBuilder();
		String model = modelBuilder.withContent("pred abc {")
		                           .withCompletionLine("some Tutors - ")
		                           .withContent("}")
		                           .build();
		alloyParser parser = buildParser(model);
		System.out.println(model);
		CompletionParams completionParams = buildCompletionParams(modelBuilder);
		var tree = parser.alloyModule();
		AlloyEvaluation alloyEvaluation = buildAlloyEvaluation(model, completionParams);

		var quantifiers = new QuantifierExtractorVisitor(model, completionParams).visit(tree);

		AbstractCompletionVisitors visitor = new DifferenceOperatorVisitor(model, completionParams, alloyEvaluation, quantifiers);
		var completionItems = visitor.visit(tree);

		completionItems.stream()
		               .distinct()
		               .sorted(Comparator.comparing(CompletionItem::getSortText))
		               .map(completionItem -> completionItem.getLabel() + " :: " + completionItem.getDetail())
		               .forEach(System.out::println);

		assertThat(completionItems, hasItems(hasProperty("label", is("Person -> Person")),
		                                     hasProperty("label", is("Person -> Student"))
		));

	}
}