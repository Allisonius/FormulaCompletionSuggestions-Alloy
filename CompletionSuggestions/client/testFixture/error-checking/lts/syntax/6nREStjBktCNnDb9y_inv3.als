sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{

}

fun lookupState: State -> State {  
	{s1, s2: State | some e: Event | s2 = s1.trans[e]}
}

/*
All states are reachable from an initial state.
*/

