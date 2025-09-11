package alloy.language.server.visitors.operators.binary;

import alloy.language.server.alloyParser;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.ClassroomFolModel;
import alloy.language.server.utils.AlloyEvaluation;
import alloy.language.server.visitors.completions.AbstractCompletionVisitors;
import alloy.language.server.visitors.BaseVisitorTest;
import alloy.language.server.visitors.extractors.QuantifierExtractorVisitor;
import alloy.language.server.visitors.completions.operators.set.IntersectionVisitor;
import org.eclipse.lsp4j.CompletionParams;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

class IntersectionVisitorTest extends BaseVisitorTest {
	@Test
	public void test() {
		CompletionModelBuilder modelBuilder = ClassroomFolModel.modelBuilder();
		String model = modelBuilder.withContent("pred abc {")
		                           .withCompletionLine("some Teacher & ")
		                           .withContent("}")
		                           .build();
		alloyParser parser = buildParser(model);
		System.out.println(model);
		CompletionParams completionParams = buildCompletionParams(modelBuilder);
		var tree = parser.alloyModule();
		AlloyEvaluation alloyEvaluation = buildAlloyEvaluation(model, completionParams);

		var quantifiers = new QuantifierExtractorVisitor(model, completionParams).visit(tree);

		AbstractCompletionVisitors visitor = new IntersectionVisitor(model, completionParams, alloyEvaluation, quantifiers);
		var completionItems = visitor.visit(tree);
		System.out.println(completionItems);
		assertThat(
				completionItems,
				containsInAnyOrder(hasProperty("label", is("Person"))));

	}
}