package alloy.language.server.models.presets;

import alloy.language.server.models.CompletionModelBuilder;

public class SkiJumpingModel {
	public static CompletionModelBuilder modelBuilder() {
		/*
		abstract sig Athlete {
	citizenOf: some Country
}

sig FemaleAthlete, MaleAthlete extends Athlete {}

sig Country {}

sig Discipline {
	event: some Event
}

sig Event {
	phase: some Phase,
	teams: set Team,
	medals: some Medal
}

sig Score{}

sig Location {}

abstract sig Medal {
	winner: one Team
}

sig BronzeMedal, SilverMedal, GoldMedal extends Medal {}

sig Performance {

	location: one Location,
	startTime: one Time,
	endTime: one Time,
	score: one Score,
	teams: some Team
}

sig Phase {
	performance: some Performance,
	nextPhase: lone Phase
}

sig Team {
	members: some Athlete,
	country: one Country
}

sig Time {
	aafter: lone Time
}

sig SkiJumping extends Discipline {}

sig MensIndividualEvent extends Event {}

sig MensTeamEvent extends Event{}

sig Points{
	distance: Int,
	pointsFromJudges: Int,
	total: Int
}

sig OverallPoints extends Score{
	ranking: Team one -> one Points
}


sig qualifyingPhase extends Phase{}

sig finalPhase extends Phase{}

sig qualifyingRound extends Performance {}

sig finalFirstRound extends Performance {}

sig finalSecondRound extends Performance {}
		 */
		CompletionModelBuilder builder = CompletionModelBuilder.modelBuilder();
		builder.withContent("abstract sig Athlete {")
				.withContent("	citizenOf: some Country")
				.withContent("}")
				.withContent("sig FemaleAthlete, MaleAthlete extends Athlete {}")
				.withContent("sig Country {}")
				.withContent("sig Discipline {")
				.withContent("	event: some Event")
				.withContent("}")
				.withContent("sig Event {")
				.withContent("	phase: some Phase,")
				.withContent("	teams: set Team,")
				.withContent("	medals: some Medal")
				.withContent("}")
				.withContent("sig Score{}")
				.withContent("sig Location {}")
				.withContent("abstract sig Medal {")
				.withContent("	winner: one Team")
				.withContent("}")
				.withContent("sig BronzeMedal, SilverMedal, GoldMedal extends Medal {}")
				.withContent("sig Performance {")
				.withContent("	location: one Location,")
				.withContent("	startTime: one Time,")
				.withContent("	endTime: one Time,")
				.withContent("	score: one Score,")
				.withContent("	teams: some Team")
				.withContent("}")
				.withContent("sig Phase {")
				.withContent("	performance: some Performance,")
				.withContent("	nextPhase: lone Phase")
				.withContent("}")
				.withContent("sig Team {")
				.withContent("	members: some Athlete,")
				.withContent("	country: one Country")
				.withContent("}")
				.withContent("sig Time {")
				.withContent("	aafter: lone Time")
				.withContent("}")
				.withContent("sig SkiJumping extends Discipline {}")
				.withContent("sig MensIndividualEvent extends Event {}")
				.withContent("sig MensTeamEvent extends Event{}")
				.withContent("sig Points{")
				.withContent("	distance: Int,")
				.withContent("	pointsFromJudges: Int,")
				.withContent("	total: Int")
				.withContent("}")
				.withContent("sig OverallPoints extends Score{")
				.withContent("	ranking: Team one -> one Points")
				.withContent("}")
				.withContent("sig qualifyingPhase extends Phase{}")
				.withContent("sig finalPhase extends Phase{}")
				.withContent("sig qualifyingRound extends Performance {}")
				.withContent("sig finalFirstRound extends Performance {}")
				.withContent("sig finalSecondRound extends Performance {}");
		return builder;
	}
}
