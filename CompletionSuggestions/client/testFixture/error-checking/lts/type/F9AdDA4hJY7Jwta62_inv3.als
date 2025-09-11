sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
	all s : State, e : Event | lone (e <: s.trans)
}

fun onlyStates[s : State] : set State->State {
	{ aux : Event.(s.trans) | s -> aux }
}

/*
All states are reachable from an initial state.
*/

