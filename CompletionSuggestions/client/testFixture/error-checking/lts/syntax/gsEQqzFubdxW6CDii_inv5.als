sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv5{
	all x, y : State | e : Event | some x->e implies some y->e
}
/*
Each event is available in at least a state.
*/

