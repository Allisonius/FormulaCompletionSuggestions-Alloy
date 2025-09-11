package alloy.language.server.models.presets;

import alloy.language.server.models.CompletionModelBuilder;

public class BinaryTreeModel {
	public static CompletionModelBuilder modelBuilder() {
		/*
		abstract sig Node {
		    left : set Node,
		    right : set Node
		}
		 */
		CompletionModelBuilder builder = CompletionModelBuilder.modelBuilder();
		builder.withContent("sig Node {")
		       .withContent("    left : set Node,")
		       .withContent("    right : set Node")
		       .withContent("}");
		return builder;
	}
}
