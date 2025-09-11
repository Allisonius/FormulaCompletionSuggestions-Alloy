sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	State in Init.^lookupState
}

/*
All the states have the same events available.
*/
fun lookupState[s: set State] : set State {  
	s.trans[Event]
}

