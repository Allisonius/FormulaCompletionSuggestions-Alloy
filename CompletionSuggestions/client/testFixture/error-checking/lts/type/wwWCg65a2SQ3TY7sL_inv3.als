sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
	trans in Event some -> one State
}

/*
All states are reachable from an initial state.
*/

