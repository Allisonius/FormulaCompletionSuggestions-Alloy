package alloy.language.server.visitors.operators.set;

import alloy.language.server.alloyParser;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.ClassroomFolModel;
import alloy.language.server.utils.AlloyEvaluation;
import alloy.language.server.visitors.completions.AbstractCompletionVisitors;
import alloy.language.server.visitors.BaseVisitorTest;
import alloy.language.server.visitors.completions.operators.set.BinarySetOperatorVisitor;
import alloy.language.server.visitors.extractors.QuantifierExtractorVisitor;
import org.eclipse.lsp4j.CompletionParams;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

class BinarySetOperatorVisitorTest extends BaseVisitorTest {

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

		AbstractCompletionVisitors visitor = new BinarySetOperatorVisitor(model, completionParams, alloyEvaluation, quantifiers);
		var completionItems = visitor.visit(tree);
		System.out.println(completionItems);
		assertThat(
				completionItems,
				hasItems(hasProperty("label", is("Person"))));
	}

	@Test
	public void testInOperator() {
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

		BinarySetOperatorVisitor visitor = new BinarySetOperatorVisitor(model, completionParams, alloyEvaluation, quantifiers);
		var completionItems = visitor.visit(tree);
		System.out.println(completionItems);

		assertThat(
				completionItems,
				hasItems(
						hasProperty("label", is("Class")),
						hasProperty("label", is("Group")),
						hasProperty("label", is("Teacher")),
						hasProperty("label", is("Student"))
				)
		);
	}

	@Test
	public void testInOperatorWithQuantifiers() {
		CompletionModelBuilder builder = ClassroomFolModel.modelBuilder()
		                                                  .withContent("pred p1 {")
		                                                  .withCompletionLine("all p: Person | Student in ")
		                                                  .withContent("}");
		String model = builder.build();

		alloyParser parser = buildParser(model);
		CompletionParams completionParams = buildCompletionParams(builder);
		var tree = parser.alloyModule();
		AlloyEvaluation alloyEvaluation = buildAlloyEvaluation(model, completionParams);

		var quantifiers = new QuantifierExtractorVisitor(model, completionParams).visit(tree);

		BinarySetOperatorVisitor visitor = new BinarySetOperatorVisitor(model, completionParams, alloyEvaluation, quantifiers);
		var completionItems = visitor.visit(tree);
		System.out.println(completionItems);

		assertThat(
				completionItems,
				hasItems(
						hasProperty("label", is("p")),
						hasProperty("label", is("Class")),
						hasProperty("label", is("Group")),
						hasProperty("label", is("Teacher"))
				)
		);
	}

	@Test
	public void testInOperatorWithQuantifiersInLeftHandSide() {
		CompletionModelBuilder builder = ClassroomFolModel.modelBuilder()
		                                                  .withContent("pred p1 {")
		                                                  .withCompletionLine("all p: Person | p in ")
		                                                  .withContent("}");
		String model = builder.build();

		alloyParser parser = buildParser(model);
		CompletionParams completionParams = buildCompletionParams(builder);
		var tree = parser.alloyModule();
		AlloyEvaluation alloyEvaluation = buildAlloyEvaluation(model, completionParams);

		var quantifiers = new QuantifierExtractorVisitor(model, completionParams).visit(tree);

		BinarySetOperatorVisitor visitor = new BinarySetOperatorVisitor(model, completionParams, alloyEvaluation, quantifiers);
		var completionItems = visitor.visit(tree);
		System.out.println(completionItems);

		assertThat(
				completionItems,
				hasItems(
						hasProperty("label", is("p")),
						hasProperty("label", is("Class")),
						hasProperty("label", is("Group")),
						hasProperty("label", is("Teacher"))
				)
		);
	}

	@Test
	public void testInOperatorWithRelationAndQuantifiers() {
		CompletionModelBuilder builder = ClassroomFolModel.modelBuilder()
		                                                  .withContent("pred p1 {")
		                                                  .withCompletionLine("all t: Tutors | t in ")
		                                                  .withContent("}");
		String model = builder.build();

		alloyParser parser = buildParser(model);
		CompletionParams completionParams = buildCompletionParams(builder);
		var tree = parser.alloyModule();
		AlloyEvaluation alloyEvaluation = buildAlloyEvaluation(model, completionParams);

		var quantifiers = new QuantifierExtractorVisitor(model, completionParams).visit(tree);

		BinarySetOperatorVisitor visitor = new BinarySetOperatorVisitor(model, completionParams, alloyEvaluation, quantifiers);
		var completionItems = visitor.visit(tree);
		System.out.println(completionItems);

		assertThat(
				completionItems,
				hasItems(
						hasProperty("label", is("Person -> Person"))
				)
		);
	}
}