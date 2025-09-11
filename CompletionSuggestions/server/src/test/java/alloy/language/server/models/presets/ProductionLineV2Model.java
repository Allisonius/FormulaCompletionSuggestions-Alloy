package alloy.language.server.models.presets;

import alloy.language.server.models.CompletionModelBuilder;

public class ProductionLineV2Model {
	public static CompletionModelBuilder modelBuilder() {
		/*
		sig Workstation {
			workers : set Worker,
			succ : set Workstation
		}
		one sig begin, end in Workstation {}
		sig Worker {}
		sig Human, Robot extends Worker {}

		abstract sig Product {
			parts : set Product
		}

		sig Material extends Product {}

		sig Component extends Product {
			workstation : set Workstation
		}

		sig Dangerous in Product {}
		 */
		CompletionModelBuilder builder = CompletionModelBuilder.modelBuilder();
		builder.withContent("sig Workstation {")
		       .withCompletionLine("workers : set Worker,")
		       .withCompletionLine("succ : set Workstation")
		       .withContent("}")
		       .withContent("one sig begin, end in Workstation {}")
		       .withContent("sig Worker {}")
		       .withContent("sig Human, Robot extends Worker {}")
		       .withContent("abstract sig Product {")
		       .withCompletionLine("parts : set Product")
		       .withContent("}")
		       .withContent("sig Material extends Product {}")
		       .withContent("sig Component extends Product {")
		       .withCompletionLine("workstation : set Workstation")
		       .withContent("}")
		       .withContent("sig Dangerous in Product {}");
		return builder;
	}
}
