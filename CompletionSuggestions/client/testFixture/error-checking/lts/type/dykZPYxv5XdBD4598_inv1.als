sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv1{
	all s : State | iden in ~s.Event.s
}

/*
There is a single initial state.
*/

