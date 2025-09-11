package alloy.language.server.models.presets;

import alloy.language.server.models.CompletionModelBuilder;

public class LTSModel {
	public static CompletionModelBuilder modelBuilder() {
		/*
		sig State {
	        trans : Event -> State
		}
		sig Init in State {}
		sig Event {}
		 */
		CompletionModelBuilder builder = CompletionModelBuilder.modelBuilder();
		builder.withContent("sig State {")
		       .withContent("    trans : Event -> State")
		       .withContent("}")
		       .withContent("sig Init in State {}")
		       .withContent("sig Event {}");
		return builder;
	}
}
