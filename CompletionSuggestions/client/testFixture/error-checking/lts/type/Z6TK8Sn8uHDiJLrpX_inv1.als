sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv1{
	all s : State | s.trans in State
}

/*
There is a single initial state.
*/

