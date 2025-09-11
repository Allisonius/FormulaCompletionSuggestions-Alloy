sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
	all s : State, e : Event | lone (e <: s.trans)
}

fun onlyStates : set State->State {
	{ aux : Event.(Init.trans) | Init -> aux }
}

/*
All states are reachable from an initial state.
*/

