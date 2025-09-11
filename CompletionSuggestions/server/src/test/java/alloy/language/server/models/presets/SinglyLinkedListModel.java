package alloy.language.server.models.presets;

import alloy.language.server.models.CompletionModelBuilder;

public class SinglyLinkedListModel {
	/**
	 * sig List {
	 *   header: lone Node
	 * }
	 *
	 * sig Node {
	 *   link: lone Node
	 * }
	 */
	public static CompletionModelBuilder modelBuilder() {
		CompletionModelBuilder builder = CompletionModelBuilder.modelBuilder();
		builder.withContent("sig List {")
		       .withCompletionLine("header: lone Node")
		       .withContent("}")
		       .withContent("sig Node {")
		       .withCompletionLine("link: lone Node")
		       .withContent("}");
		return builder;
	}

}
