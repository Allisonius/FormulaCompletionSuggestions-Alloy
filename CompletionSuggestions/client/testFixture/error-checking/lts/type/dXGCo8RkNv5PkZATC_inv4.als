sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	all s : Init <: trans | State in s.^(trans.Event)
}


/*
All the states have the same events available.
*/

