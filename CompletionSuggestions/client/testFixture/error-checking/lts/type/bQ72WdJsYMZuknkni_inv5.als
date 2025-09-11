sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv5{
	all s : State, e : Event | s.trans in e
}

/*
Each event is available in at least a state.
*/

