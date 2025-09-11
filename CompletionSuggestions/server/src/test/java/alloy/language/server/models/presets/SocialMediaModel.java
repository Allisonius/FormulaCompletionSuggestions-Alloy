package alloy.language.server.models.presets;

import alloy.language.server.models.CompletionModelBuilder;

public class SocialMediaModel {
	public static CompletionModelBuilder modelBuilder() {
		/*
		sig User {
			follows : set User,
			sees : set Photo,
			posts : set Photo,
			suggested : set User
		}

		sig Influencer extends User {}

		sig Photo {
			date : one Day
		}
		sig Ad extends Photo {}
		sig Day {}
		 */
		CompletionModelBuilder builder = CompletionModelBuilder.modelBuilder();
		builder.withContent("sig User {")
		       .withContent("    follows : set User,")
		       .withContent("    sees : set Photo,")
		       .withContent("    posts : set Photo,")
		       .withContent("    suggested : set User")
		       .withContent("}")
		       .withContent("sig Influencer extends User {}")
		       .withContent("sig Photo {")
		       .withContent("    date : one Day")
		       .withContent("}")
		       .withContent("sig Ad extends Photo {}")
		       .withContent("sig Day {}");
		return builder;
	}
}
