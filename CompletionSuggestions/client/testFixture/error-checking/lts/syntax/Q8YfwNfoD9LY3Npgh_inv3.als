sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
	all s:State | all disj e1, e2:Events | e1.(s.trans)!=e2.(s.trans)
}

/*
All states are reachable from an initial state.
*/

