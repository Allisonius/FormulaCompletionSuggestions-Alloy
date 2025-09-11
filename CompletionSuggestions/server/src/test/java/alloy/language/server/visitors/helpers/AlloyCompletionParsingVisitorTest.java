package alloy.language.server.visitors.helpers;

import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.CourseModel;
import alloy.language.server.visitors.BaseVisitorTest;
import org.eclipse.lsp4j.CompletionParams;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class AlloyCompletionParsingVisitorTest extends BaseVisitorTest {

	@Test
	public void testIncompleteLineBeforeEndOfBlock() {
		CompletionModelBuilder modelBuilder = CourseModel.modelBuilder();
		String model = modelBuilder.withContent("pred p1 {")
		                           .withCompletionLine("all p: Person | some p. ")
		                           .withContent("no Professor")
		                           .withContent("}")
		                           .build();
		var parser = buildParser(model);
		CompletionParams completionParams = buildCompletionParams(modelBuilder);

		AlloyCompletionParsingVisitor visitor = new AlloyCompletionParsingVisitor(completionParams);
		var endPosition = visitor.visit(parser.alloyModule());
		System.out.println(completionParams.getPosition());
		System.out.println(endPosition);
	}

}