sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv5{
	all x, y : State | x->y in trans implies y->y in trans
}
/*
Each event is available in at least a state.
*/

