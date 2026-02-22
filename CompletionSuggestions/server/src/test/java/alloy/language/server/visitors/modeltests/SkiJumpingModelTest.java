package alloy.language.server.visitors.modeltests;

import alloy.language.server.ConfigManager;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.CTree;
import alloy.language.server.models.presets.SkiJumpingModel;
import alloy.language.server.visitors.BaseVisitorTest;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class SkiJumpingModelTest extends BaseVisitorTest {
	private final CompletionModelBuilder modelBuilder = SkiJumpingModel.modelBuilder();

	@BeforeAll
	public static void setup() {
		// Ensure that the new completion provider is enabled for testing
		ConfigManager.getInstance().setUseNewCompletionProvider(true);
	}

	@BeforeAll
	public static void setUp() {
//		ConfigManager.getInstance().setUseGeneratorCompletion(true);
	}

	//all s:Discipline,e:s.event, gm:e.medals, t:e.teams,ffr:finalFirstRound,fsr:finalSecondRound |no tt:e.teams - t | add[fsr.score.ranking[tt].
	@Test
	public void testSkiJumpingModel() {
		modelBuilder.withContent("pred p1 {")
				.withCompletionLine("all s:Discipline,e:s.event, gm:e.medals, t:e.teams,ffr:finalFirstRound,fsr:finalSecondRound |no tt:e.teams - t | add[fsr.score.ranking[tt].")
				.withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItem(hasProperty("label", is("total"))));
	}

	//no tt: Team -
	@Test
	public void testSkiJumpingModel2() {
		modelBuilder.withContent("pred p1[t: Team, p: Phase]{")
				.withCompletionLine("no tt: Team -")
				.withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItem(hasProperty("label", is("t"))));
	}
}
