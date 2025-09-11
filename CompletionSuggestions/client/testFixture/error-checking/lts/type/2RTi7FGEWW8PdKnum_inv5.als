sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv5{
	all x : State | x->Event
}
/*
Each event is available in at least a state.
*/

