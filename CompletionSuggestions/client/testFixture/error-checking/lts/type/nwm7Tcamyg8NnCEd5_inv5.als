sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv5{
	all s1, s2 : State, e1, e2 : Event | some e1.(s1.trans) and e2.(s2.trans) implies e1 = e2
}

/*
Each event is available in at least a state.
*/

