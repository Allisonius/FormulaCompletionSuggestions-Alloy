package alloy.language.server.models.presets;

import alloy.language.server.models.CompletionModelBuilder;

public class GraphModel {
	public static CompletionModelBuilder modelBuilder() {
		/*
		sig Node {
			adj : set Node
		}
		 */
		CompletionModelBuilder builder = CompletionModelBuilder.modelBuilder();
		builder.withContent("sig Node {")
		       .withCompletionLine("adj : set Node")
		       .withContent("}");
		return builder;
	}
}
