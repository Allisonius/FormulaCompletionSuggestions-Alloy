sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv5{
	all s1, s2: State | s1.(trans.State) = s2.(trans.State)
}

/*
Each event is available in at least a state.
*/

