/*
 * Signatures
 *
 * Your model should contain the following (and potentially other) signatures.
 * If necessary, you have to make some of the signatures abstract and
 * make them extend other signatures.
 */


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

/////////////////////////////////////////////////////////
//Sport Specific

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
