package alloy.language.server.models.presets;

import alloy.language.server.models.CompletionModelBuilder;

public class CVModel {
	public static CompletionModelBuilder modelBuilder() {
		/*
		abstract sig Source {}
		sig User extends Source {
		    profile : set Work,
		    visible : set Work
		}
		sig Institution extends Source {}

		sig Id {}
		sig Work {
		    ids : some Id,
		    source : one Source
		}
		 */
		CompletionModelBuilder builder = CompletionModelBuilder.modelBuilder();
		builder.withContent("abstract sig Source {}")
		       .withContent("sig User extends Source {")
		       .withContent("    profile : set Work,")
		       .withContent("    visible : set Work")
		       .withContent("}")
		       .withContent("sig Institution extends Source {}")
		       .withContent("sig Id {}")
		       .withContent("sig Work {")
		       .withContent("    ids : some Id,")
		       .withContent("    source : one Source")
		       .withContent("}");
		return builder;
	}

}
