package alloy.language.server.utils;

import alloy.language.server.document.AlloyDocumentModel;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.ArrayModel;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class ModelStatsTest {

	@Test
	public void testArrayModelStats() {
		CompletionModelBuilder modelBuilder = ArrayModel.modelBuilder();
		modelBuilder.withContent("fact Reachable {")
				.withContent("  Element = Array.i2e[Int]")
				.withContent("}");
		modelBuilder.withContent("pred NoConflict {")
				.withContent("all idx: Array.i2e.Element | lone Array.i2e[idx]")
				.withContent("}");
		modelBuilder.withContent("fun lengthOfArray: Int {")
				.withContent("Array.length")
				.withContent("}");
		String model = modelBuilder.build();
		AlloyDocumentModel documentModel = new AlloyDocumentModel("", model);
		var stats = AlloyInstanceUtils.modelStats(documentModel);
		System.out.println("Model Stats: " + stats);
		assertThat(stats, is(notNullValue()));
		assertThat(stats.numSignatures(), is(2));
		assertThat(stats.numRelations(), is(2));
		assertThat(stats.numPredicates(), is(1));
		assertThat(stats.numFacts(), is(1));
		assertThat(stats.numOfFormulas(), is(2));
	}
}
