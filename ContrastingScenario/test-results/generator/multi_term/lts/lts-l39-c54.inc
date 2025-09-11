sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

/*The LTS does not contain deadlocks, ie, each state has at least a transition.*/
pred inv1o {
	all s:State | some s.trans
}

/*There is a single initial state.*/
pred inv2o {
	one Init
}

/*The LTS is deterministic, ie, each state has at most a transition for each event.*/
pred inv3o {
	all s : State, e : Event | lone e.(s.trans)
}

/*All states are reachable from an initial state.*/
pred inv4o {
	let ts = { s1,s2:State | some e:Event | s1->e->s2 in trans } | all s:State | some i:Init | s in i.^ts
}

/*All the states have the same events available.*/
pred inv5o {
	all s1,s2:State | s1.trans.State = s2.trans.State
}

/*Each event is available in at least a state.*/
pred inv6o {
	State.trans.State = Event
}

/*The LTS is reversible, ie, from a reacheable state it is always possible \nto return to an initial state.*/
pred inv7o {
	let ts = { s1,s2:State | some e:Event | s1->e->s2 in 
}