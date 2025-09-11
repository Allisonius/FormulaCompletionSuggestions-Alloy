sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
	always (all s: State | lone s.state.State)
}

/*
All states are reachable from an initial state.
*/

