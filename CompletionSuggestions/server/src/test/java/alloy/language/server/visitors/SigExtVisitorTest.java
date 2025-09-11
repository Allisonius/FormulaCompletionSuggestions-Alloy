package alloy.language.server.visitors;

import alloy.language.server.alloyParser;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.utils.AlloyEvaluation;
import alloy.language.server.visitors.completions.SigExtVisitor;
import alloy.language.server.visitors.extractors.QuantifierExtractorVisitor;
import org.eclipse.lsp4j.CompletionItem;
import org.eclipse.lsp4j.CompletionParams;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

class SigExtVisitorTest extends BaseVisitorTest {

	@Test
	public void testSigInVisitorWithIncompleteLastLine() {
		CompletionModelBuilder modelBuilder = CompletionModelBuilder.modelBuilder();
		String model = modelBuilder
				.withContent("sig Person {}")
		                           .withContent("sig Student in Person {}")
		                           .withCompletionLine("sig Teacher in")
		                           .build();
		alloyParser parser = buildParser(model);
		CompletionParams completionParams = buildCompletionParams(modelBuilder);
		System.out.println(model);

		var tree = parser.alloyModule();
		AlloyEvaluation alloyEvaluation = buildAlloyEvaluation(model, completionParams);
		var quantifiers = new QuantifierExtractorVisitor(model, completionParams).visit(tree);
		SigExtVisitor sigExtVisitor = new SigExtVisitor(model, completionParams, alloyEvaluation, quantifiers);
		List<CompletionItem> completionItemList = sigExtVisitor.visit(tree);
		printCompletionItems(completionItemList);

//		assert completionItemList.size() == 2;

		assertThat(completionItemList, hasItems(
				hasProperty("label", is("Person")),
				hasProperty("label", is("Student"))
		));
	}
}