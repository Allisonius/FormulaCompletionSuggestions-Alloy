sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	State in (fromState[Init]).^fromState
}

/*
All the states have the same events available.
*/
fun fromState[s: set State] : set State {  
	s.trans[Event]
}

