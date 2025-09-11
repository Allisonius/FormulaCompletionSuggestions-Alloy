sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv1{
	State.trans in State
}

/*
There is a single initial state.
*/

