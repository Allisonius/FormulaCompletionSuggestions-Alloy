package alloy.language.server.models.presets;

import alloy.language.server.models.CompletionModelBuilder;

public class ClassroomFolModel {
	public static CompletionModelBuilder modelBuilder() {
		/*
		sig Person  {
		  Tutors : set Person,
		  Teaches : set Class
		}

		sig Group {}

		sig Class  {
		  Groups : Person -> Group
		}

		sig Teacher extends Person {}

		sig Student in Person  {}
		 */
		CompletionModelBuilder builder = CompletionModelBuilder.modelBuilder();
		builder.withContent("sig Person {")
		       .withContent("  Tutors : set Person,")
		       .withContent("  Teaches : set Class")
		       .withContent("}")
		       .withContent("sig Group {}")
		       .withContent("sig Class {")
		       .withContent("  Groups : Person -> Group")
		       .withContent("}")
		       .withContent("sig Student in Person {}")
		       .withContent("sig Teacher extends Person {}");
		return builder;
	}
}
