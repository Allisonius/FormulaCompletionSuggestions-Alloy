package alloy.language.server.models.presets;

import alloy.language.server.models.CompletionModelBuilder;

public class CTree {
	public static CompletionModelBuilder modelBuilder() {
		/*
		abstract sig Color {}
		one sig Red extends Color {}
		one sig Blue extends Color {}

		sig Node {
		  neighbors: set Node,
		  color: one Color
		}
		 */
		CompletionModelBuilder builder = CompletionModelBuilder.modelBuilder();
		builder.withContent("abstract sig Color {}")
		       .withContent("one sig Red extends Color {}")
		       .withContent("one sig Blue extends Color {}")
		       .withContent("sig Node {")
		       .withContent("  neighbors: set Node,")
		       .withContent("  color: one Color ")
		       .withContent("}");
		return builder;
	}
}
