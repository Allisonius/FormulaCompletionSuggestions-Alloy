sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

// The station has at least one entry and one exit
pred inv1 { // same as oracle
	some Entry
	some Exit
}

// Signals belong to one track
pred inv2 {
	all s:Signal|one t:Track | s in t.signals
}

// Exit tracks are those without successor
pred inv3 {
	all t:Track| t in Exit iff no t.^succs
}

// Entry tracks are those without predecessors
pred inv4 {
	all t:Track| t in Entry iff t not in Track.^succs
}

// Junctions are the tracks with more than one predecessor
pred inv5 { // same as oracle
	all t : Track | t not in Junction iff lone succs.t
}

// Entry tracks must have a speed signal
pred inv6 {
	all e:Entry|some s:Speed| s in e.signals
}

// The station has no cycles
pred inv7 {
	all t:Track| t not in t.^succs
}

// It should be possible to reach every exit from every entry
pred inv8 {
	all disj t1,t2: Track|t1 in Entry and t2 in Exit =>  t2 in 
}

// Tracks not followed by junctions do not have semaphores
pred inv9 {
	all t:Track, s:Semaphore | no t.succs & Junction => s not in t.signals
}

// Every track before a junction has a semaphore
pred inv10 { // same as oracle
	all j : Junction, t : succs.j | some t.signals & Semaphore
}
