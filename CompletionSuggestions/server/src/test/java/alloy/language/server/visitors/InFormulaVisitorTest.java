package alloy.language.server.visitors;

import alloy.language.server.alloyParser;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.ClassroomFolModel;
import alloy.language.server.utils.AlloyEvaluation;
import alloy.language.server.visitors.extractors.QuantifierExtractorVisitor;
import alloy.language.server.visitors.completions.operators.binary.InFormulaVisitor;
import org.eclipse.lsp4j.CompletionParams;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

class InFormulaVisitorTest extends BaseVisitorTest {

	@Test
	public void test() {
		CompletionModelBuilder builder = ClassroomFolModel.modelBuilder()
		                                                  .withContent("pred p1 {")
		                                                  .withCompletionLine("Person in ")
		                                                  .withContent("}");
		String model = builder.build();

		alloyParser parser = buildParser(model);
		CompletionParams completionParams = buildCompletionParams(builder);
		var tree = parser.alloyModule();
		AlloyEvaluation alloyEvaluation = buildAlloyEvaluation(model, completionParams);

		var quantifiers = new QuantifierExtractorVisitor(model, completionParams).visit(tree);

		InFormulaVisitor visitor = new InFormulaVisitor(model, completionParams, alloyEvaluation, quantifiers);
		var completionItems = visitor.visit(tree);
		System.out.println(completionItems);

		assertThat(completionItems, empty());
	}

	@Test
	public void testWithQuantifiers() {
		CompletionModelBuilder builder = ClassroomFolModel.modelBuilder()
		                                                  .withContent("pred p1 {")
		                                                  .withCompletionLine("some p: Person | p in ")
		                                                  .withContent("}");
		String model = builder.build();

		alloyParser parser = buildParser(model);
		CompletionParams completionParams = buildCompletionParams(builder);
		var tree = parser.alloyModule();
		AlloyEvaluation alloyEvaluation = buildAlloyEvaluation(model, completionParams);

		var quantifiers = new QuantifierExtractorVisitor(model, completionParams).visit(tree);

		InFormulaVisitor visitor = new InFormulaVisitor(model, completionParams, alloyEvaluation, quantifiers);
		var completionItems = visitor.visit(tree);
		printCompletionItems(completionItems);
	}
}