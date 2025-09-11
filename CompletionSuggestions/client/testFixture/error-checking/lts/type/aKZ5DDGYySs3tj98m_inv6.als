sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv6{
	all e: Event | some State.trans[e]
}

/*
The LTS is reversible, ie, from a reacheable state it is always possible 
to return to an initial state.
*/
fun edge : State -> State {
  all s1, s2: State | some s1.trans.s2
}

