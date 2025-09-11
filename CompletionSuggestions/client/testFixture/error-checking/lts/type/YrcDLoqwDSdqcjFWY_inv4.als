sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	all s:State | Init.Event.s in trans
}

/*
All the states have the same events available.
*/

