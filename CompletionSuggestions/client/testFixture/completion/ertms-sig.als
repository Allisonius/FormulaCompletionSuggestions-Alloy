/**
An Alloy model of the Hybrid ERTMS/ETCS Level 3 Concept (HL3) based on the "Principles"
document at https://www.southampton.ac.uk/abz2018/information/case-study.page
launched  as part of the ABZ 2018 call for case study contributions.

A technical report describing the corresponding Electrum model and its development can
be found at http://haslab.github.io/Electrum/ertms.pdf.

This model is available at http://haslab.github.io/Electrum/ertms.als and its visualizer theme
at http://haslab.github.io/Electrum/ertms_als.thm. A similar Electrum encoding can be found at
http://haslab.github.io/Electrum/ertms.ele.

@author: Nuno Macedo
**/
open util/ordering[Time] as T
open util/ordering[VSS] as V
open util/ordering[TTD] as D

sig Time {}

// the states that can be assigned to each VSS
abstract sig State {}
sig Unknown, Free, Ambiguous, Occupied extends State {}

/**
Structural components of the HL3 model, including the track configurations and train state,
and the communication between on-board and the trackside systems.
**/

// virtual sub-sections of the track, totally ordered
sig VSS {
	state 			: State one -> Time,
	disconnect_ptimer	: set Time,
	integrity_loss_ptimer	: set Time,
	jumping			: Train lone -> Time
}

// trackside train detection sections, totally ordered
sig TTD {
	start 			: VSS,
	end 			: VSS,
	shadow_timer_A	: set Time,
	shadow_timer_B	: set Time,
	ghost_ptimer 	: set Time
}
fact TTD_facts {
	all ttd : TTD | ttd.end.gte[ttd.start]
}

// available trains, always positioned in the track
sig Train {
	pos_front 		: VSS one -> Time,
	pos_rear 		: VSS one -> Time,
	connected		: set Time,
	report_front	: set Time,
	report_rear 	: set Time,
	MA 			: VSS one -> Time,
	mute_timer	: set Time,
	integrity_timer	: set Time
}
