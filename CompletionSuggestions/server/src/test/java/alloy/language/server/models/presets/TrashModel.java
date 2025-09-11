package alloy.language.server.models.presets;

import alloy.language.server.models.CompletionModelBuilder;

public class TrashModel {
	public static CompletionModelBuilder modelBuilder() {
		/*
		sig File {
			link : set File
		}

		sig Trash in File {}

		sig Protected in File {}
		 */
		CompletionModelBuilder builder = CompletionModelBuilder.modelBuilder();
		builder.withContent("sig File {")
		       .withCompletionLine("link : set File")
		       .withContent("}")
		       .withContent("sig Trash in File {}")
		       .withContent("sig Protected in File {}");
		return builder;
	}
}
