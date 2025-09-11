sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	all s: State | some (*{ss: State, e: Event | ss.trans.e}.s & Init)
}

/*
All the states have the same events available.
*/

