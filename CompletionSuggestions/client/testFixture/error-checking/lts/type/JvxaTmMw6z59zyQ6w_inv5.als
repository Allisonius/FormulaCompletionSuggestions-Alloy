sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv5{
	all s : State, e : Event | some (s.trans)<:e
}

/*
Each event is available in at least a state.
*/

