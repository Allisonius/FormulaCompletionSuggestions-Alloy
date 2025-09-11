package alloy.language.server.visitors;

import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.CourseModel;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

class CompletionTermVisitorTest extends BaseVisitorTest {

    private final CompletionModelBuilder completionModelBuilder = CourseModel.modelBuilder();

    @Test
    public void testFindCompletionTerm() {
        completionModelBuilder.withContent("pred p1 {")
                .withCompletionLine("   all c: Course | no Student and some teaches.")
                .withContent("}");
        String model = completionModelBuilder.build();
        var parser = buildParser(model);
        var tree = parser.alloyModule();
        var completionParams = buildCompletionParams(completionModelBuilder);
        CompletionTermVisitor visitor = new CompletionTermVisitor(model, completionParams.getPosition());
        String term = visitor.visit(tree);
        assertNotNull(term);
        assertEquals("teaches", term);
    }

    @Test
    public void testFindSimpleCompletionTerm() {
        completionModelBuilder.withContent("pred p1 {")
                .withCompletionLine("   some teaches.")
                .withContent("}");
        String model = completionModelBuilder.build();
        var parser = buildParser(model);
        var tree = parser.alloyModule();
        var completionParams = buildCompletionParams(completionModelBuilder);
        CompletionTermVisitor visitor = new CompletionTermVisitor(model, completionParams.getPosition());
        String term = visitor.visit(tree);
        assertNotNull(term);
        assertEquals("teaches", term); // Assuming it finds the first term
    }

    @Test
    public void testFindCompletionTermBeforeBinaryOperator() {
        completionModelBuilder.withContent("pred p1 {")
                .withCompletionLine("   no Student and")
                .withContent("}");
        String model = completionModelBuilder.build();
        var parser = buildParser(model);
        var tree = parser.alloyModule();
        var completionParams = buildCompletionParams(completionModelBuilder);
        CompletionTermVisitor visitor = new CompletionTermVisitor(model, completionParams.getPosition());
        String term = visitor.visit(tree);
        assertNotNull(term);
        assertEquals("Student", term); // Assuming it finds the first term before the binary operator
    }

    @Test
    public void testFindCompletionTermInsideQuantifier() {
        completionModelBuilder.withContent("pred p1 {")
                .withCompletionLine("   all c: teaches. ")
                .withContent("}");
        String model = completionModelBuilder.build();
        var parser = buildParser(model);
        var tree = parser.alloyModule();
        var completionParams = buildCompletionParams(completionModelBuilder);
        CompletionTermVisitor visitor = new CompletionTermVisitor(model, completionParams.getPosition());
        String term = visitor.visit(tree);
        assertNotNull(term);
        assertEquals("teaches", term); // Assuming it finds the term inside the quantifier
    }

    @Test
    public void testFindCompletionTermInsideQuantifier2() {
        completionModelBuilder.withContent("pred p1 {")
                .withCompletionLine("   all c : Course, p : c. ")
                .withContent("}");
        String model = completionModelBuilder.build();
        var parser = buildParser(model);
        var tree = parser.alloyModule();
        var completionParams = buildCompletionParams(completionModelBuilder);
        CompletionTermVisitor visitor = new CompletionTermVisitor(model, completionParams.getPosition());
        String term = visitor.visit(tree);
        assertNotNull(term);
        assertEquals("c", term); // Assuming it finds the term inside the quantifier
    }

    @Test
    public void testFindCompletionTermWithDotOps() {
        completionModelBuilder.withContent("pred p1 {")
                .withCompletionLine("   some teaches.Course.")
                .withContent("}");
        String model = completionModelBuilder.build();
        var parser = buildParser(model);
        var tree = parser.alloyModule();
        var completionParams = buildCompletionParams(completionModelBuilder);
        CompletionTermVisitor visitor = new CompletionTermVisitor(model, completionParams.getPosition());
        String term = visitor.visit(tree);
        assertNotNull(term);
        assertEquals("teaches.Course", term); // Assuming it finds the first term
    }
}