package alloy.language.server.models.presets;

import alloy.language.server.models.CompletionModelBuilder;

public class TrashLTLModel {
	public static CompletionModelBuilder modelBuilder() {
		/*
		sig System {}
		var sig File {
			var link : lone File
		}
		var sig Trash in File {}
		var sig Protected in File {}
		 */
		CompletionModelBuilder builder = CompletionModelBuilder.modelBuilder();
		builder.withContent("sig System {}")
		       .withContent("var sig File {")
		       .withContent("    var link : lone File")
		       .withContent("}")
		       .withContent("var sig Trash in File {}")
		       .withContent("var sig Protected in File {}");
		return builder;
	}

}
