sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv5{
	all s : State, e : Event | e.(s.trans) in State.trans
}

/*
Each event is available in at least a state.
*/

