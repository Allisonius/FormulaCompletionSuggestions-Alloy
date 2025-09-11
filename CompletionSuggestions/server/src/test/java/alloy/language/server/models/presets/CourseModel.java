package alloy.language.server.models.presets;

import alloy.language.server.models.CompletionModelBuilder;

public class CourseModel {
	public static CompletionModelBuilder modelBuilder() {
		/*
		open util/ordering[Grade]

		sig Person {
			teaches : set Course,
			enrolled : set Course,
			projects : set Project
		}

		sig Professor, Student in Person {}

		sig Course {
			projects : set Project,
			grades : Person -> Grade
		}

		sig Project {}

		sig Grade {}
		 */
		CompletionModelBuilder builder = CompletionModelBuilder.modelBuilder();
		builder.withContent("open util/ordering[Grade]")
				.withContent("")
				.withContent("sig Person {")
				.withContent("  teaches : set Course,")
				.withContent("  enrolled : set Course,")
				.withContent("  projects : set Project")
				.withContent("}")
				.withContent("sig Professor, Student in Person {}")
				.withContent("sig Course {")
				.withContent("  projects : set Project,")
				.withContent("  grades : Person -> Grade")
				.withContent("}")
				.withContent("sig Project {}")
				.withContent("sig Grade {}");
		return builder;
	}
}
