sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv1{
	iden in trans.State.Event
}

/*
There is a single initial state.
*/

