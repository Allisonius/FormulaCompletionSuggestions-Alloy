sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

/*The LTS does not contain deadlocks, ie, each state has at least a transition.*/
pred inv1 { //same as oracle
	all s:State | some s.trans
}

/*There is a single initial state.*/
pred inv2 { //same as oracle
	one Init
}

/*The LTS is deterministic, ie, each state has at most a transition for each event.*/
pred inv3 { 
	all s:State, e:Event | lone s.trans[e]
}

/*All states are reachable from an initial state.*/
pred inv4 {
	Init.^{x,y: State | some x.trans.y} = State
}

/*All the states have the same events available.*/
pred inv5 { //same as oracle
	all s1,s2:State | s1.trans.State = s2.trans.State
}

/*Each event is available in at least a state.*/
pred inv6 {
	Event = State.trans.State
}

/*The LTS is reversible, ie, from a reacheable state it is always possible \nto return to an initial state.*/
pred inv7 { //same as oracle
	let ts = {s1,s2:State | some e:Event | s1->e->s2 in trans} |
	all s:Init.^ts | some i:Init | i in s.^ts
}
