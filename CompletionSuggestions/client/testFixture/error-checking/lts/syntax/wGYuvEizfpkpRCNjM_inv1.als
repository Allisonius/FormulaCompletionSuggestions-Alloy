sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv1{
	some s:State in s.trans
}

/*
There is a single initial state.
*/

