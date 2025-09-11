package alloy.language.server.models.presets;

import alloy.language.server.models.CompletionModelBuilder;

public class ProductionLineModel {
	public static CompletionModelBuilder modelBuilder() {
		/*
		open util/ordering[Position]

		// Consider the following model of an automated production line
		// The production line consists of several positions in sequence
		sig Position {}

		// Products are either components assembled in the production line or
		// other resources (e.g. pre-assembled products or base materials)
		sig Product {}

		// Components are assembled in a given position from other parts
		sig Component extends Product {
		    parts : set Product,
		    position : one Position
		}
		sig Resource extends Product {}

		// Robots work somewhere in the production line
		sig Robot {
		    position : one Position
		}
		 */
		CompletionModelBuilder builder = CompletionModelBuilder.modelBuilder();
		builder.withContent("open util/ordering[Position]")
		       .withContent("sig Position {}")
		       .withContent("sig Product {}")
		       .withContent("sig Component extends Product {")
		       .withContent("    parts : set Product,")
		       .withContent("    position : one Position")
		       .withContent("}")
		       .withContent("sig Resource extends Product {}")
		       .withContent("sig Robot {")
		       .withContent("    position : one Position")
		       .withContent("}");
		return builder;
	}
}
