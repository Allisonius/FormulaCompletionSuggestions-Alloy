package alloy.language.server.visitors.extractors;

import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.CVModel;
import alloy.language.server.models.presets.CourseModel;
import alloy.language.server.visitors.BaseVisitorTest;
import org.eclipse.lsp4j.CompletionParams;
import org.junit.jupiter.api.Test;

import java.util.Map;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

class QuantifierExtractorVisitorTest extends BaseVisitorTest {

	@Test
	public void testSimpleQuantifier() {
		CompletionModelBuilder modelBuilder = CourseModel.modelBuilder();
		String model =
				modelBuilder.withContent("pred p1 {").withCompletionLine("all p: Person | some p ").withContent("}").build();
		var parser = buildParser(model);
		CompletionParams completionParams = buildCompletionParams(modelBuilder);

		QuantifierExtractorVisitor visitor = new QuantifierExtractorVisitor(model, completionParams, Map.of());
		var quantifierMap = visitor.visit(parser.alloyModule());
		System.out.println(quantifierMap);
		assertThat(quantifierMap, hasKey("p"));
	}

	@Test
	public void testMultipleSimpleQuantifier() {
		CompletionModelBuilder modelBuilder = CourseModel.modelBuilder();
		String model =
				modelBuilder.withContent("pred p1 {").withCompletionLine("all p: Person, c: Course | some p ").withContent("}").build();
		var parser = buildParser(model);
		CompletionParams completionParams = buildCompletionParams(modelBuilder);

		QuantifierExtractorVisitor visitor = new QuantifierExtractorVisitor(model, completionParams);
		var quantifierMap = visitor.visit(parser.alloyModule());
		System.out.println(quantifierMap);
		assertThat(quantifierMap, hasKey("p"));
		assertThat(quantifierMap, hasKey("c"));
	}

	@Test
	public void testMultipleCombinedQuantifier() {
		CompletionModelBuilder modelBuilder = CourseModel.modelBuilder();
		String model =
				modelBuilder.withContent("pred p1 {").withCompletionLine("all a, b: Person, c: Course | some p ").withContent("}").build();
		var parser = buildParser(model);
		CompletionParams completionParams = buildCompletionParams(modelBuilder);

		QuantifierExtractorVisitor visitor = new QuantifierExtractorVisitor(model, completionParams);
		var quantifierMap = visitor.visit(parser.alloyModule());
		System.out.println(quantifierMap);
		assertThat(quantifierMap, hasKey("a"));
		assertThat(quantifierMap, hasKey("b"));
		assertThat(quantifierMap, hasKey("c"));

		assertThat(quantifierMap.get("a").getText(), is("Person"));
		assertThat(quantifierMap.get("b").getText(), is("Person"));
		assertThat(quantifierMap.get("c").getText(), is("Course"));
	}

	@Test
	public void testSimpleQuantifierForIncompleteExprWithCompareOps() {
		CompletionModelBuilder modelBuilder = CourseModel.modelBuilder();
		String model =
				modelBuilder.withContent("pred p1 {").withCompletionLine("all p: Person | some p in").withContent("}").build();
		var parser = buildParser(model);
		CompletionParams completionParams = buildCompletionParams(modelBuilder);

		QuantifierExtractorVisitor visitor = new QuantifierExtractorVisitor(model, completionParams);
		var quantifierMap = visitor.visit(parser.alloyModule());
		System.out.println(quantifierMap);
		assertThat(quantifierMap, hasKey("p"));
	}

	@Test
	public void testSimpleQuantifierForIncompleteExprWithCompareOpsWithImplies() {
		CompletionModelBuilder modelBuilder = CourseModel.modelBuilder();
		String model =
				modelBuilder.withContent("pred p1 {").withCompletionLine("all p: Person | some p in Course => no Course.").withContent("}").build();
		var parser = buildParser(model);
		CompletionParams completionParams = buildCompletionParams(modelBuilder);

		QuantifierExtractorVisitor visitor = new QuantifierExtractorVisitor(model, completionParams);
		var quantifierMap = visitor.visit(parser.alloyModule());
		System.out.println(quantifierMap);
		assertThat(quantifierMap, hasKey("p"));
	}

	@Test
	public void testSimpleQuantifierForIncompleteExprWithDifferenceOps() {
		CompletionModelBuilder modelBuilder = CourseModel.modelBuilder();
		String model =
				modelBuilder.withContent("pred p1 {").withCompletionLine("all p: Person -").withContent("}").build();
		var parser = buildParser(model);
		CompletionParams completionParams = buildCompletionParams(modelBuilder);

		QuantifierExtractorVisitor visitor = new QuantifierExtractorVisitor(model, completionParams);
		var quantifierMap = visitor.visit(parser.alloyModule());
		System.out.println(quantifierMap);
		assertThat(quantifierMap.size(), is(0));
	}

	@Test
	public void testNestedQuantifiers() {
		CompletionModelBuilder modelBuilder = CourseModel.modelBuilder();
		String model =
				modelBuilder.withContent("pred p1 {").withCompletionLine("all p: Person, q: p.projects | some p in ").withContent("}").build();
		var parser = buildParser(model);
		CompletionParams completionParams = buildCompletionParams(modelBuilder);

		QuantifierExtractorVisitor visitor = new QuantifierExtractorVisitor(model, completionParams);
		var quantifierMap = visitor.visit(parser.alloyModule());
		System.out.println(quantifierMap);
		assertThat(quantifierMap, hasKey("p"));
		assertThat(quantifierMap, hasKey("q"));

		assertThat(quantifierMap.get("p").getText(), is("Person"));
		assertThat(quantifierMap.get("q").getText(), is("Person.projects"));
	}

	@Test
	public void testQuantifiersWithOpeningParenthesis() {
		CompletionModelBuilder modelBuilder = CourseModel.modelBuilder();
		String model =
				modelBuilder.withContent("pred p1 {").withCompletionLine("all p: Person | some (p in ").withContent("}").build();
		var parser = buildParser(model);
		CompletionParams completionParams = buildCompletionParams(modelBuilder);

		QuantifierExtractorVisitor visitor = new QuantifierExtractorVisitor(model, completionParams);
		var quantifierMap = visitor.visit(parser.alloyModule());
		System.out.println(quantifierMap);
		assertThat(quantifierMap, hasKey("p"));

		assertThat(quantifierMap.get("p").getText(), is("Person"));
	}

	@Test
	public void testQuantifiersWithOpeningParenthesisAndImplies() {
		CompletionModelBuilder modelBuilder = CVModel.modelBuilder();
		String model =
				modelBuilder.withContent("pred p1 {").withCompletionLine("all u : User, disj x,y : u.profile | x.source = y.source implies no (x.").withContent("}").build();
		var parser = buildParser(model);
		CompletionParams completionParams = buildCompletionParams(modelBuilder);

		QuantifierExtractorVisitor visitor = new QuantifierExtractorVisitor(model, completionParams);
		var quantifierMap = visitor.visit(parser.alloyModule());
		System.out.println(quantifierMap);
		assertThat(quantifierMap, hasKey("u"));
		assertThat(quantifierMap, hasKey("x"));
		assertThat(quantifierMap, hasKey("y"));

		assertThat(quantifierMap.get("u").getText(), is("User"));
		assertThat(quantifierMap.get("x").getText(), is("User.profile"));
		assertThat(quantifierMap.get("y").getText(), is("User.profile"));
	}

	@Test
	public void testQuantifierInLogicalExpressions() {
		CompletionModelBuilder modelBuilder = CourseModel.modelBuilder();
		String model =
				modelBuilder.withContent("pred p1 {").withCompletionLine("all p: Person | some p or all p: Project | some p ").withContent("}").build();
		var parser = buildParser(model);
		CompletionParams completionParams = buildCompletionParams(modelBuilder);

		QuantifierExtractorVisitor visitor = new QuantifierExtractorVisitor(model, completionParams, Map.of());
		var quantifierMap = visitor.visit(parser.alloyModule());
		System.out.println(quantifierMap);
		assertThat(quantifierMap, hasKey("p"));
		assertThat(quantifierMap.get("p").getText(), is("Project"));
	}
}