sig Track {
	prox : set Track,
	signal : lone Signal
}
sig Junction extends Track {}
sig Entry, Exit in Track {}

sig Signal {}
var sig Green in Signal {}

sig Train {
	var pos : lone Track
}

pred fact1 {
	// A track is a junction iff it has more than one successor or more than one predecessor
	all t : Track | t not in Junction iff (lone t.prox and lone prox.t)
}

pred fact2 {
	// No cycles
	no t : Track | t in t.^prox
}

pred fact3 {
	// Signals belong to one and only one track
	all s : Signal | one signal.s
}

pred fact4 {
	// All tracks before junctions have signals
	all j : Junction, t : prox.j | some t.signal
}

pred fact5 {
	// Tracks not followed by junctions do not have semaphores
	all t : Track | no prox.t & Junction implies no t.signal
}

pred fact6 {
	// Entry tracks are those without predecessors and exit tracks are those without no successors
	all t : Track | t in Entry iff no prox.t
	all t : Track | t in Exit iff no t.prox
}

fact Layout {
	fact1
	fact2
	fact3
	fact4
	fact5
	fact6
}

// Intially all signals are red
pred prop1 { //same as oracle
	no Green
}

// Every signal will eventually become green
pred prop2 { //same as oracle
	all s : Signal | eventually s in Green
}

// Trains never move
pred prop3 { //same as oracle
	always pos' = pos
}

// There are no collisions between trains
pred prop4 {
	always pos.~pos in iden
}

// Signals are always alternating
pred prop6 { //same as oracle
	all s : Signal | always eventually (s in Green) and always eventually (s not in Green)
}

// All trains inside the station will eventually leave the station
pred prop7 { //same as oracle
	all t : Train | always (some t.pos implies eventually no t.pos)
}

// A train at a track with a red signal can only move after the signal becomes green
pred prop8 { //same as oracle
	all t : Train, p : Track | always (t.
}

// Is is always the case that at most one signal before a junction can be green
pred prop10 { //same as oracle
	all j : Junction | always lone (prox.j).signal & Green	
}

// It is always the case that trains inside the station where previously at a an entry track
pred prop11 { //same as oracle
	all t : Train | always (some t.pos implies once some t.pos & Entry)
}

// Trains that left the station never return
pred prop13 { //same as oracle
	all t : Train | always ((no t.pos and once some t.pos) implies always no t.pos)
}

// Trains cannot remain forever stopped in same position
pred prop15 { //same as oracle
	all t : Train, p : Track | not (eventually always t.pos = p)
}

// A train in an exit track was always inside the station since it arrived at an entry track
pred prop16 { //same as oracle
	all t : Train | always (some t.pos & Exit implies (some t.pos since some t.pos & Entry))
}
