sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv1{
	all s : State | iden in ~s.s
}

/*
There is a single initial state.
*/

