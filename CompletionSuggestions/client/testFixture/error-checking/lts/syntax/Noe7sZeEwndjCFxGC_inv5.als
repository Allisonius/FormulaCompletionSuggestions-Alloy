sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv5{
	all disj s, s1 | s.trans.State = s1.trans.State 
}

/*
Each event is available in at least a state.
*/

