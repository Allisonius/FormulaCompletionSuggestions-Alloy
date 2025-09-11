package alloy.language.server.utils;

import alloy.language.server.alloyParser;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.utils.AlloyEvaluation;
import alloy.language.server.utils.AlloyExpressionParsingUtils;
import alloy.language.server.visitors.BaseVisitorTest;
import org.eclipse.lsp4j.CompletionItem;
import org.eclipse.lsp4j.CompletionParams;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;

class QualifierNameParsingWithQuantifiersTest extends BaseVisitorTest {

	@Test
	public void testQuantifiedType() {
		CompletionModelBuilder modelBuilder = CompletionModelBuilder.modelBuilder();
		String model = modelBuilder.withCompletionLine("all x: Class | x")
		                           .build();
		alloyParser parser = buildParser(model);
		var expression = parser.expr();
		String qualName = AlloyExpressionParsingUtils.findQualifierName(expression);
		System.out.println(qualName);
		assertThat(qualName, is("Class"));
	}

	@Test
	public void testQuantifiedTypeWithExtension() {
		CompletionModelBuilder modelBuilder = CompletionModelBuilder.modelBuilder();
		String model = modelBuilder.withCompletionLine("all x: Class | x.Teaches")
		                           .build();
		alloyParser parser = buildParser(model);
		var expression = parser.expr();
		String qualName = AlloyExpressionParsingUtils.findQualifierName(expression);
		System.out.println(qualName);
		assertThat(qualName, is("Class.Teaches"));
	}

	@Test
	public void testExpressionWithMultipleQuantifierTypes() {
		CompletionModelBuilder modelBuilder = CompletionModelBuilder.modelBuilder();
		String model = modelBuilder.withCompletionLine("all x: Student, y: Class | x.y")
		                           .build();
		alloyParser parser = buildParser(model);
		var expression = parser.expr();
		String qualName = AlloyExpressionParsingUtils.findQualifierName(expression);
		System.out.println(qualName);
		assertThat(qualName, is("Student.Class"));
	}

	@Test
	public void testExpressionWithSameQuantifierType() {
		CompletionModelBuilder modelBuilder = CompletionModelBuilder.modelBuilder();
		String model = modelBuilder.withCompletionLine("all x: Student, y: Student | x.y")
		                           .build();
		alloyParser parser = buildParser(model);
		var expression = parser.expr();
		String qualName = AlloyExpressionParsingUtils.findQualifierName(expression);
		System.out.println(qualName);
		assertThat(qualName, is("Student.Student"));
	}

	@Test
	public void testExpressionWithNestedQuantifiers() {
		CompletionModelBuilder modelBuilder = CompletionModelBuilder.modelBuilder();
		String model = modelBuilder.withCompletionLine("all x: Student, y: x.Class | Teacher.y")
		                           .build();
		alloyParser parser = buildParser(model);
		var expression = parser.expr();
		String qualName = AlloyExpressionParsingUtils.findQualifierName(expression);
		System.out.println(qualName);
		assertThat(qualName, is("Teacher.Student.Class"));
	}
}