package alloy.language.server.suggestions;

import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.CourseModel;
import alloy.language.server.utils.AlloyInstanceUtils;
import alloy.language.server.visitors.BaseVisitorTest;
import edu.mit.csail.sdg.ast.Command;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

import java.io.IOException;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class SuggestionImpactTest extends BaseVisitorTest {

    private final CompletionModelBuilder modelBuilder = CourseModel.modelBuilder();

    @Test
    public void testComparisonWithBaseline() throws IOException {
        String model = modelBuilder.build();
        var world = AlloyInstanceUtils.buildAlloyModel(model);
        String baseline = "no Student";
        String completionLine = "no Student and some Professor";
        var diffIff = world.parseOneExpressionFromString(baseline + " <=> " + completionLine);
        System.out.println(diffIff);
        Command diffIffCheckCommand = new Command(true, -1, -1, -1, diffIff);
//        Command checkCommand = new Command(null, expr, "compareWithBaseline", true, -1, -1, -1, -1, -1, -1, null, null, expr, null);
        var instance = AlloyInstanceUtils.buildInstanceFromCommand(world, diffIffCheckCommand);
        System.out.println("Diff Iff Check Result: " + instance.satisfiable());

        Command diffIffRunCommand = new Command(false, -1, -1, -1, diffIff);
        instance = AlloyInstanceUtils.buildInstanceFromCommand(world, diffIffRunCommand);
        System.out.println(instance.getOriginalCommand());
        System.out.println("Diff Iff Run Result: " + instance.satisfiable());

        var A_and_B = world.parseOneExpressionFromString("(" + baseline + ") and (" + completionLine + ")");
        Command aAndBCheckCommand = new Command(false, -1, -1, -1, A_and_B);
        instance = AlloyInstanceUtils.buildInstanceFromCommand(world, aAndBCheckCommand);
        System.out.println("A and B Run Result: " + instance.satisfiable());

        var A_and_notB = world.parseOneExpressionFromString("(" + baseline + ") and !(" + completionLine + ")");
        Command aAndNotBCheckCommand = new Command(false, -1, -1, -1, A_and_notB);
        instance = AlloyInstanceUtils.buildInstanceFromCommand(world, aAndNotBCheckCommand);
        System.out.println("A and !B Run Result: " + instance.satisfiable());

        var notA_and_B = world.parseOneExpressionFromString("!(" + baseline + ") and (" + completionLine + ")");
        Command notAAndBCheckCommand = new Command(false, -1, -1, -1, notA_and_B);
        instance = AlloyInstanceUtils.buildInstanceFromCommand(world, notAAndBCheckCommand);
        System.out.println("!A and B Run Result: " + instance.satisfiable());

        var notA_and_notB = world.parseOneExpressionFromString("!(" + baseline + ") and !(" + completionLine + ")");
        Command notAAndNotBCheckCommand = new Command(false, -1, -1, -1, notA_and_notB);
        instance = AlloyInstanceUtils.buildInstanceFromCommand(world, notAAndNotBCheckCommand);
        System.out.println("!A and !B Run Result: " + instance.satisfiable());
    }

    @Test
    public void testImpactOfSuggestion() throws IOException {
        String model = modelBuilder.build();
        var world = AlloyInstanceUtils.buildAlloyModel(model);
        String baseline = "no Student";
        String completionLine = "no Student and some Professor";

        var impact = AlloyInstanceUtils.getSuggestionImpact(world, baseline, completionLine);
        System.out.println("Impact of Suggestion: " + impact);
        assertThat(impact, is(notNullValue()));
        assertThat(impact.A_and_B(), is(true));
        assertThat(impact.A_and_not_B(), is(true));
        assertThat(impact.not_A_and_B(), is(false));
        assertThat(impact.not_A_and_not_B(), is(true));
    }

    @Test
    public void testWithEmptyBaseline() throws IOException {
        String model = modelBuilder.build();
        var world = AlloyInstanceUtils.buildAlloyModel(model);
        String baseline = "{}";
        String completionLine = "some Professor";

        var impact = AlloyInstanceUtils.getSuggestionImpact(world, baseline, completionLine);
        assertThat(impact, is(notNullValue()));
        assertThat(impact.A_and_B(), is(true));
        assertThat(impact.A_and_not_B(), is(true));
        assertThat(impact.not_A_and_B(), is(false));
        assertThat(impact.not_A_and_not_B(), is(false));
    }

    @Test
    public void testWithConflictingFact() throws IOException {
        String model = modelBuilder.withContent("fact {no Professor}").build();
        var world = AlloyInstanceUtils.buildAlloyModel(model);
        String baseline = "{}";
        String completionLine = "some Professor";

        var impact = AlloyInstanceUtils.getSuggestionImpact(world, baseline, completionLine);
        assertThat(impact, is(notNullValue()));
        assertThat(impact.A_and_B(), is(false));
        assertThat(impact.A_and_not_B(), is(true));
        assertThat(impact.not_A_and_B(), is(false));
        assertThat(impact.not_A_and_not_B(), is(false));
    }
}
