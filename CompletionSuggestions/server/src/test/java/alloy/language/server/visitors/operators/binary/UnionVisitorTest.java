package alloy.language.server.visitors.operators.binary;

import alloy.language.server.alloyParser;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.ClassroomFolModel;
import alloy.language.server.utils.AlloyEvaluation;
import alloy.language.server.visitors.BaseVisitorTest;
import alloy.language.server.visitors.extractors.QuantifierExtractorVisitor;
import alloy.language.server.visitors.completions.operators.set.UnionVisitor;
import org.eclipse.lsp4j.CompletionParams;
import org.junit.jupiter.api.Test;

public class UnionVisitorTest extends BaseVisitorTest {

	@Test
	public void testAfterComparatorOp() {
		CompletionModelBuilder modelBuilder = ClassroomFolModel.modelBuilder();
		String model = modelBuilder.withContent("pred p1 {")
				.withCompletionLine("Person in Student +")
				.withContent("}")
				.build();
		alloyParser parser = buildParser(model);
		CompletionParams completionParams = buildCompletionParams(modelBuilder);
		var tree = parser.alloyModule();
		AlloyEvaluation alloyEvaluation = buildAlloyEvaluation(model, completionParams);

		var quantifiers = new QuantifierExtractorVisitor(model, completionParams).visit(tree);

		UnionVisitor visitor = new UnionVisitor(model, completionParams, alloyEvaluation, quantifiers);
		var completionItems = visitor.visit(tree);

		System.out.println(completionItems);
	}

	@Test
	public void testAfterNegatedComparatorOp() {
		CompletionModelBuilder modelBuilder = ClassroomFolModel.modelBuilder();
		String model = modelBuilder.withContent("pred p1 {")
		                           .withCompletionLine("Person not in Student +")
		                           .withContent("}")
		                           .build();
		alloyParser parser = buildParser(model);
		CompletionParams completionParams = buildCompletionParams(modelBuilder);
		var tree = parser.alloyModule();
		AlloyEvaluation alloyEvaluation = buildAlloyEvaluation(model, completionParams);

		var quantifiers = new QuantifierExtractorVisitor(model, completionParams).visit(tree);

		UnionVisitor visitor = new UnionVisitor(model, completionParams, alloyEvaluation, quantifiers);
		var completionItems = visitor.visit(tree);

		System.out.println(completionItems);
	}
}
