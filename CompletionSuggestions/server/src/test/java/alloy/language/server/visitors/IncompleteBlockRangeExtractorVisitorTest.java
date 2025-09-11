package alloy.language.server.visitors;

import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.CourseModel;
import org.eclipse.lsp4j.Position;
import org.eclipse.lsp4j.Range;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import static org.hamcrest.Matchers.is;
import static org.junit.jupiter.api.Assertions.*;

class IncompleteBlockRangeExtractorVisitorTest extends BaseVisitorTest {

    private final CompletionModelBuilder modelBuilder = CourseModel.modelBuilder();

    @Test
    public void testIncompleteBlockRange() {
        modelBuilder.withContent("pred p1 {")
                .withCompletionLine("   all c: Course | no Student and some teaches.")
                .withContent("}");
        String model = modelBuilder.build();
        var completionParams = buildCompletionParams(modelBuilder);
        var parser = buildParser(model);
        var tree = parser.alloyModule();
        IncompleteBlockRangeExtractorVisitor
                extractor = new IncompleteBlockRangeExtractorVisitor(model, completionParams.getPosition());
        Range range = extractor.visit(tree);
        assertThat(range, is(not(nullValue())));
        assertThat(range.getStart(), is(new Position(completionParams.getPosition().getLine() + 1,
                completionParams.getPosition().getCharacter())));
        assertThat(range.getEnd(), is(new Position(completionParams.getPosition().getLine() + 1, -1)));
    }

    @Test
    public void textIncompleteBlockRangeForInline() {
        modelBuilder.withContent("pred p1 {")
                .withCompletionLine("   all c: Course | some teacher. and no Student")
                .withContent("}");
        String model = modelBuilder.build();
        var completionParams = buildCompletionParams(modelBuilder);
        var completionPosition = completionParams.getPosition();
        var newPosition = new Position(completionPosition.getLine(), completionPosition.getCharacter() - 15);
        completionParams.setPosition(newPosition);
        var parser = buildParser(model);
        var tree = parser.alloyModule();
        IncompleteBlockRangeExtractorVisitor
                extractor = new IncompleteBlockRangeExtractorVisitor(model, completionParams.getPosition());
        Range range = extractor.visit(tree);
        assertThat(range, is(not(nullValue())));
        assertThat(range.getStart(), is(new Position(newPosition.getLine() + 1, newPosition.getCharacter())));
        assertThat(range.getEnd(), is(new Position(completionPosition.getLine() + 1, -1)));
    }

    @Test
    public void testMultiBlockRange() {
        modelBuilder.withContent("pred p1 {")
                .withCompletionLine("   all c: Course | no Student and some teaches.")
                .withContent("   all c: Course | no Student and some teaches")
                .withContent("   some Teacher")
                .withContent("}");
        String model = modelBuilder.build();
        var completionParams = buildCompletionParams(modelBuilder);
        var parser = buildParser(model);
        var tree = parser.alloyModule();
        IncompleteBlockRangeExtractorVisitor
                extractor = new IncompleteBlockRangeExtractorVisitor(model, completionParams.getPosition());
        Range range = extractor.visit(tree);
        assertThat(range, is(not(nullValue())));
        assertThat(range.getStart(), is(new Position(completionParams.getPosition().getLine() + 1,
                completionParams.getPosition().getCharacter())));
        assertThat(range.getEnd(), is(new Position(completionParams.getPosition().getLine() + 3, -1)));
    }

    @Test
    public void testMultiBlockRangeWithOpenParenthesis() {
        modelBuilder.withContent("pred p1 {")
                .withCompletionLine("   all c: Course | no Student and some teaches.")
                .withContent("   all c: Course | no Student and some teaches")
                .withContent("   some Teacher");
        String model = modelBuilder.build();
        var completionParams = buildCompletionParams(modelBuilder);
        var parser = buildParser(model);
        var tree = parser.alloyModule();
        IncompleteBlockRangeExtractorVisitor
                extractor = new IncompleteBlockRangeExtractorVisitor(model, completionParams.getPosition());
        Range range = extractor.visit(tree);
        assertThat(range, is(not(nullValue())));
        assertThat(range.getStart(), is(new Position(completionParams.getPosition().getLine() + 1,
                completionParams.getPosition().getCharacter())));
        assertThat(range.getEnd(), is(new Position(completionParams.getPosition().getLine() + 3, -1)));
    }

    @Test
    public void testNestedBlockRange() {
        modelBuilder.withContent("pred p1 {")
                .withContent("   all c: Course {")
                .withContent("	  no Student")
                .withCompletionLine("	  no Student and some teaches.")
                .withContent("   }")
                .withContent("}");
        String model = modelBuilder.build();
        var completionParams = buildCompletionParams(modelBuilder);
        var parser = buildParser(model);
        var tree = parser.alloyModule();
        IncompleteBlockRangeExtractorVisitor
                extractor = new IncompleteBlockRangeExtractorVisitor(model, completionParams.getPosition());
        Range range = extractor.visit(tree);
        assertThat(range, is(not(nullValue())));
        assertThat(range.getStart(), is(new Position(completionParams.getPosition().getLine() + 1,
                completionParams.getPosition().getCharacter())));
        assertThat(range.getEnd(), is(new Position(completionParams.getPosition().getLine() + 1, -1)));
    }

}