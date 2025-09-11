sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{

}

fun lookupState: set State -> set State {  
	s.trans[Event]
}

/*
All states are reachable from an initial state.
*/

