sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
	all s: State | lone State.trans.s
}

/*
All states are reachable from an initial state.
*/

