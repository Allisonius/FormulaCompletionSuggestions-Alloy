package alloy.language.server.visitors;

import alloy.language.server.document.AlloyDocumentModel;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.CourseModel;
import alloy.language.server.utils.AlloyEvaluation;
import alloy.language.server.utils.CodeUtils;
import alloy.language.server.visitors.completions.AlloyCompletionVisitorDispatcher;
import org.eclipse.lsp4j.CompletionParams;
import org.junit.jupiter.api.Test;

class AlloyCompletionVisitorDispatcherTest extends BaseVisitorTest {

	@Test
	void visitAndBuildCompletions() {
		CompletionModelBuilder courseModel = CourseModel.modelBuilder();
		courseModel.withContent("pred p1 {").withCompletionLine("   all c: Course | some teaches.").withContent("}");
		String model = courseModel.build();
		AlloyDocumentModel documentModel = new AlloyDocumentModel("", model);

		CompletionParams completionParams = buildCompletionParams(courseModel);
		AlloyEvaluation alloyEvaluation = new AlloyEvaluation(documentModel.getModel(),
		                                                      documentModel.getDefaultSolution());
		AlloyCompletionVisitorDispatcher visitors = new AlloyCompletionVisitorDispatcher(alloyEvaluation);

		var parser = CodeUtils.buildAlloyParser(model);
		var tree = parser.alloyModule();

		var completionItems = visitors.visitAndBuildCompletions(model, completionParams, tree);
		System.out.println("Completion Items: ");
		completionItems.stream().map(completionItem -> completionItem.getLabel() + completionItem.getDetail()).forEach(
				System.out::println);
	}
}