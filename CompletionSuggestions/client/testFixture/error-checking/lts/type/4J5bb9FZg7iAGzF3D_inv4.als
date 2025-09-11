sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	all s:State | some (s.Event.^~trans):>Init
}

/*
All the states have the same events available.
*/

