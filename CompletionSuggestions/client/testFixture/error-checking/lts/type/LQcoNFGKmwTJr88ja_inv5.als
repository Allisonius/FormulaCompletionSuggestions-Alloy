sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv5{
	all x, y, z : State | some e : Event | x->y in trans implies y->x in trans
}

/*
Each event is available in at least a state.
*/

