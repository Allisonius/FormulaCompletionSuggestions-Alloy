package alloy.language.server.visitors.operators.binary;

import alloy.language.server.alloyParser;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.ClassroomFolModel;
import alloy.language.server.models.presets.LTSModel;
import alloy.language.server.utils.AlloyEvaluation;
import alloy.language.server.visitors.BaseVisitorTest;
import alloy.language.server.visitors.extractors.QuantifierExtractorVisitor;
import alloy.language.server.visitors.completions.operators.set.DotVisitor;
import org.eclipse.lsp4j.CompletionItem;
import org.eclipse.lsp4j.CompletionParams;
import org.junit.jupiter.api.Test;

import java.util.Comparator;
import java.util.stream.Collectors;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

class DotVisitorTest extends BaseVisitorTest {

	@Test
	public void test() {
		CompletionModelBuilder modelBuilder = ClassroomFolModel.modelBuilder();
		String model =
				modelBuilder.withContent("pred abc {").withCompletionLine("some Class. ").withContent("}").build();
		alloyParser parser = buildParser(model);
		CompletionParams completionParams = buildCompletionParams(modelBuilder);
		var tree = parser.alloyModule();
		AlloyEvaluation alloyEvaluation = buildAlloyEvaluation(model, completionParams);

		var quantifiers = new QuantifierExtractorVisitor(model, completionParams).visit(tree);

		DotVisitor visitor = new DotVisitor(model, completionParams, alloyEvaluation, quantifiers);
		var completionItems = visitor.visit(tree);
		completionItems.stream()
		               .distinct()
		               .sorted(Comparator.comparing(CompletionItem::getSortText))
		               .map(completionItem -> completionItem.getLabel() + " :: " + completionItem.getDetail())
		               .forEach(System.out::println);

		assertThat(completionItems, hasItems(hasProperty("label", is("Groups"))));
	}

	@Test
	public void testWithQuantifiers() {
		CompletionModelBuilder modelBuilder = ClassroomFolModel.modelBuilder();
		String model = modelBuilder.withContent("pred abc {")
		                           .withCompletionLine("some p: Person | some Tutors. ")
		                           .withContent("}")
		                           .build();
		alloyParser parser = buildParser(model);
		System.out.println(model);
		CompletionParams completionParams = buildCompletionParams(modelBuilder);
		var tree = parser.alloyModule();
		AlloyEvaluation alloyEvaluation = buildAlloyEvaluation(model, completionParams);

		var quantifiers = new QuantifierExtractorVisitor(model, completionParams).visit(tree);

		DotVisitor visitor = new DotVisitor(model, completionParams, alloyEvaluation, quantifiers);
		var completionItems = visitor.visit(tree)
		                             .stream()
		                             .sorted(Comparator.comparing(CompletionItem::getSortText))
		                             .collect(Collectors.toList());
		completionItems.stream()
		               .distinct()
		               .sorted(Comparator.comparing(CompletionItem::getSortText))
		               .map(completionItem -> completionItem.getLabel() + " :: " + completionItem.getDetail())
		               .forEach(System.out::println);

		assertThat(completionItems, hasItem(hasProperty("label", is("p"))));
	}

	@Test
	public void testWithQuantifiersInQualifier() {
		CompletionModelBuilder modelBuilder = ClassroomFolModel.modelBuilder();
		String model = modelBuilder.withContent("pred abc {")
		                           .withCompletionLine("some p: Person | some p. ")
		                           .withContent("}")
		                           .build();
		alloyParser parser = buildParser(model);
		System.out.println(model);
		CompletionParams completionParams = buildCompletionParams(modelBuilder);
		var tree = parser.alloyModule();
		AlloyEvaluation alloyEvaluation = buildAlloyEvaluation(model, completionParams);

		var quantifiers = new QuantifierExtractorVisitor(model, completionParams).visit(tree);

		DotVisitor visitor = new DotVisitor(model, completionParams, alloyEvaluation, quantifiers);
		var completionItems = visitor.visit(tree)
		                             .stream()
		                             .sorted(Comparator.comparing(CompletionItem::getSortText))
		                             .collect(Collectors.toList());
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItem(hasProperty("label", is("Tutors"))));
		assertThat(completionItems, hasItem(hasProperty("label", is("Teaches"))));
	}

	@Test
	public void testDotParseTree() {
		CompletionModelBuilder modelBuilder = ClassroomFolModel.modelBuilder();
		String model = modelBuilder.withContent("pred abc {")
		                           .withCompletionLine("some Class.Groups and no Class.Groups. ")
		                           .withContent("}")
		                           .build();
		alloyParser parser = buildParser(model);
		CompletionParams completionParams = buildCompletionParams(modelBuilder);
		var tree = parser.alloyModule();
		AlloyEvaluation alloyEvaluation = buildAlloyEvaluation(model, completionParams);

		var quantifiers = new QuantifierExtractorVisitor(model, completionParams).visit(tree);

		DotVisitor visitor = new DotVisitor(model, completionParams, alloyEvaluation, quantifiers);
		var completionItems = visitor.visit(tree);
		completionItems.stream()
		               .distinct()
		               .sorted(Comparator.comparing(CompletionItem::getSortText))
		               .map(completionItem -> completionItem.getLabel() + " :: " + completionItem.getDetail())
		               .forEach(System.out::println);

		assertThat(completionItems, hasItems(hasProperty("label", is("Group"))));
	}

	@Test
	public void testWithLetExpression() {
		// TODO 1/21/25: Parse let expression and store in quantifiers like map
		CompletionModelBuilder modelBuilder = LTSModel.modelBuilder();
		modelBuilder = modelBuilder.withContent("pred abc {")
		                           .withCompletionLine(
				                           "let ts = { s1,s2:State | some e:Event | s1->e->s2 in trans } | all s:Init.^ts | some i:Init | i in s. ")
		                           .withContent("}");
		var completionItems = generateCompletionForVisitor(modelBuilder, DotVisitor.class);
		printCompletionItems(completionItems);
	}
}