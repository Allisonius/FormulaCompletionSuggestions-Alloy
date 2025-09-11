sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv1{
	all e : Event | trans.State.e
}

/*
There is a single initial state.
*/

