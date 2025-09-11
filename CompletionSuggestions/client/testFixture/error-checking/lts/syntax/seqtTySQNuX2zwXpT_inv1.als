sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv1{
	all s1 : State , some s2 : State | s1 -> s2 in trans
}

/*
There is a single initial state.
*/

