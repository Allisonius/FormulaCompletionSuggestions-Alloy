sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	 for s: State | some i: Init | i in trans.s.Event
}

/*
All the states have the same events available.
*/

