sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
	all s : State | all disj e1, e2 : Event | e1 in (s.trans).State and e2 in (s.trans).State implies s1 = s2
}

/*
All states are reachable from an initial state.
*/

