sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
	(Init.trans)
}

/*
All states are reachable from an initial state.
*/

