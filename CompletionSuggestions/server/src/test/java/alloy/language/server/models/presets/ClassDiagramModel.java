package alloy.language.server.models.presets;

import alloy.language.server.models.CompletionModelBuilder;

public class ClassDiagramModel {
	public static CompletionModelBuilder modelBuilder() {
		/*
		sig Class {
		  ext: lone Class
		}

		one sig Object extends Class {}
		 */
		CompletionModelBuilder builder = CompletionModelBuilder.modelBuilder();
		builder.withContent("sig Class {")
		       .withContent("  ext: lone Class")
		       .withContent("}")
		       .withContent("one sig Object extends Class {}");
		return builder;
	}
}
