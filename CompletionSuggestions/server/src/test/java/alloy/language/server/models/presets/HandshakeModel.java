package alloy.language.server.models.presets;

import alloy.language.server.models.CompletionModelBuilder;

public class HandshakeModel {
	public static CompletionModelBuilder modelBuilder() {
		/*
		module handshake

		sig Person {
		    spouse: Person,
		    shaken: set Person
		}

		one sig Jocelyn, Hilary extends Person {}
		 */
		CompletionModelBuilder builder = CompletionModelBuilder.modelBuilder();
		builder.withContent("module handshake")
		       .withContent("sig Person {")
		       .withContent("    spouse: Person,")
		       .withContent("    shaken: set Person")
		       .withContent("}")
		       .withContent("one sig Jocelyn, Hilary extends Person {}");
		return builder;
	}
}
