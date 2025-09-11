package alloy.language.server.models.presets;

import alloy.language.server.models.CompletionModelBuilder;

public class BemplModel {
	public static CompletionModelBuilder modelBuilder() {
		/*
		sig Room {}
		one sig secure_lab extends Room {}

		abstract sig Person {
		  owns : set Key
		}
		sig Employee extends Person {}
		sig Researcher extends Person {}

		sig Key {
		  authorized: one Employee,
		  opened_by: one Room
		}

		pred CanEnter(p: Person, r:Room) {
			r in p.owns.opened_by
		}

		fact {
		  no Employee.owns
		}

		// Should help create tests.
		assert no_thief_in_seclab {
		  all p : Person | CanEnter[p, secure_lab] implies p in Researcher
		}
		check no_thief_in_seclab
		 */
		CompletionModelBuilder builder = CompletionModelBuilder.modelBuilder();
		builder.withContent("sig Room {}")
		       .withContent("one sig secure_lab extends Room {}")
		       .withContent("abstract sig Person {")
		       .withContent("  owns : set Key")
		       .withContent("}")
		       .withContent("sig Employee extends Person {}")
		       .withContent("sig Researcher extends Person {}")
		       .withContent("sig Key {")
		       .withContent("  authorized: one Employee,")
		       .withContent("  opened_by: one Room")
		       .withContent("}")
		       .withContent("pred CanEnter(p: Person, r:Room) {")
		       .withContent("  r in p.owns.opened_by")
		       .withContent("}")
		       .withContent("fact {")
		       .withContent("  no Employee.owns")
		       .withContent("}")
		       .withContent("assert no_thief_in_seclab {")
		       .withContent("  all p : Person | CanEnter[p, secure_lab] implies p in Researcher")
		       .withContent("}")
		       .withContent("check no_thief_in_seclab");
		return builder;
	}
}
