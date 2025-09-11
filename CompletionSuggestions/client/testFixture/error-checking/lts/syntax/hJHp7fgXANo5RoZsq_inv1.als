sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv1{
	all State.trans
}

/*
There is a single initial state.
*/

