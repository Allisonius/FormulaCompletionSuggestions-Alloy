package alloy.language.server.visitors.operators.binary;

import alloy.language.server.alloyParser;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.utils.AlloyEvaluation;
import alloy.language.server.visitors.BaseVisitorTest;
import alloy.language.server.visitors.completions.operators.binary.ArrowExprVisitor;
import alloy.language.server.visitors.extractors.QuantifierExtractorVisitor;
import org.eclipse.lsp4j.CompletionItem;
import org.eclipse.lsp4j.CompletionParams;
import org.junit.jupiter.api.Test;

import java.util.Comparator;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

class ArrowExprVisitorTest extends BaseVisitorTest {

	@Test
	public void test() {
		CompletionModelBuilder modelBuilder = CompletionModelBuilder.modelBuilder();
		modelBuilder.withContent("sig Person {}")
				.withContent("sig Group {}")
				.withContent("sig Class {")
				.withCompletionLine(" groups: Person -> ")
				.withContent("}");
		String model = modelBuilder.build();

		alloyParser parser = buildParser(model);
		System.out.println(model);
		CompletionParams completionParams = buildCompletionParams(modelBuilder);
		var tree = parser.alloyModule();
		AlloyEvaluation alloyEvaluation = buildAlloyEvaluation(model, completionParams);

		var quantifiers = new QuantifierExtractorVisitor(model, completionParams).visit(tree);

		ArrowExprVisitor visitor = new ArrowExprVisitor(model, completionParams, alloyEvaluation, quantifiers);
		var completionItems = visitor.visit(tree);

		completionItems.stream()
		               .distinct()
		               .sorted(Comparator.comparing(CompletionItem::getSortText))
		               .map(completionItem -> completionItem.getLabel() + " :: " + completionItem.getDetail())
		               .forEach(System.out::println);

		assertThat(completionItems, hasItems(
				hasProperty("label", is("Person")),
				hasProperty("label", is("Group")),
				hasProperty("label", is("Class"))
		));
	}

}