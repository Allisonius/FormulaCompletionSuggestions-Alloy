package alloy.language.server.visitors;

import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.CourseModel;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

class BaselineExpressionExtractorVisitorTest extends BaseVisitorTest {

	private final CompletionModelBuilder modelBuilder = CourseModel.modelBuilder();

	@Test
	public void noBaseline() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("   all c: Course | no Student &")
		            .withContent("}");
		String model = modelBuilder.build();
		var parser = buildParser(model);
		var tree = parser.alloyModule();
		var completionParams = buildCompletionParams(modelBuilder);
		BaselineExpressionExtractorVisitor visitor = new BaselineExpressionExtractorVisitor(model, completionParams.getPosition());
		String baseline = visitor.visit(tree);
		assertThat(baseline, is(nullValue()));
	}

	@Test
	public void testBasic() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("   all c: Course | no Student and some teaches.")
		            .withContent("}");
		String model = modelBuilder.build();
		var parser = buildParser(model);
		var tree = parser.alloyModule();
		var completionParams = buildCompletionParams(modelBuilder);
		BaselineExpressionExtractorVisitor visitor = new BaselineExpressionExtractorVisitor(model, completionParams.getPosition());
		String baseline = visitor.visit(tree);
		assertThat(baseline, is(not(nullValue())));
		assertThat(baseline, is("all c: Course | no Student"));
	}

	@Test
	public void testWithMultipleAnds() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("   all c: Course | no Student and some teaches and no teaches.")
		            .withContent("}");
		String model = modelBuilder.build();
		var parser = buildParser(model);
		var tree = parser.alloyModule();
		var completionParams = buildCompletionParams(modelBuilder);
		BaselineExpressionExtractorVisitor visitor = new BaselineExpressionExtractorVisitor(model, completionParams.getPosition());
		String baseline = visitor.visit(tree);
		assertThat(baseline, is(not(nullValue())));
		assertThat(baseline, is("all c: Course | no Student and some teaches"));
	}

	@Test
	public void testWithOr() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("   all c: Course | no Student or some teaches.")
		            .withContent("}");
		String model = modelBuilder.build();
		var parser = buildParser(model);
		var tree = parser.alloyModule();
		var completionParams = buildCompletionParams(modelBuilder);
		BaselineExpressionExtractorVisitor visitor = new BaselineExpressionExtractorVisitor(model, completionParams.getPosition());
		String baseline = visitor.visit(tree);
		assertThat(baseline, is(not(nullValue())));
		assertThat(baseline, is("all c: Course | no Student"));
	}

	@Test
	public void testWithMixedOps() {
		modelBuilder.withContent("pred p1 {")
		            .withCompletionLine("   all c: Course | no Student and some teaches or no teaches.")
		            .withContent("}");
		String model = modelBuilder.build();
		var parser = buildParser(model);
		var tree = parser.alloyModule();
		var completionParams = buildCompletionParams(modelBuilder);
		BaselineExpressionExtractorVisitor visitor = new BaselineExpressionExtractorVisitor(model, completionParams.getPosition());
		String baseline = visitor.visit(tree);
		assertThat(baseline, is(not(nullValue())));
		assertThat(baseline, is("all c: Course | no Student and some teaches"));
	}
}