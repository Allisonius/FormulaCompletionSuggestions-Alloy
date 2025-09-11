sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	State in ^fromState[Init]
}

/*
All the states have the same events available.
*/
fun fromState[s1: State] : set State {  
	s1.trans[Event]
}

