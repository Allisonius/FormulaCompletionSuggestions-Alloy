sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	 all s: State | some i: Init | i in  Event.(trans.s)
}

/*
All the states have the same events available.
*/

