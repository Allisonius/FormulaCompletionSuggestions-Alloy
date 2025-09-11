package alloy.language.server.models.presets;

import alloy.language.server.models.CompletionModelBuilder;

public class TrainStationLTLModel {
	public static CompletionModelBuilder modelBuilder() {
		/*
		sig Track {
			prox : set Track,
			signal : lone Signal
		}
		sig Junction extends Track {}
		sig Entry, Exit in Track {}

		sig Signal {}
		var sig Green in Signal {}

		sig Train {
			var pos : lone Track
		}
		 */
		CompletionModelBuilder builder = CompletionModelBuilder.modelBuilder();
		builder.withContent("sig Track {")
		       .withContent("    prox : set Track,")
		       .withContent("    signal : lone Signal")
		       .withContent("}")
		       .withContent("sig Junction extends Track {}")
		       .withContent("sig Entry, Exit in Track {}")
		       .withContent("")
		       .withContent("sig Signal {}")
		       .withContent("var sig Green in Signal {}")
		       .withContent("")
		       .withContent("sig Train {")
		       .withContent("    var pos : lone Track")
		       .withContent("}");
		return builder;
	}
}
