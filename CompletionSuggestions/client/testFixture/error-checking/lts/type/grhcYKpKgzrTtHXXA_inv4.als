sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	all s : Init <: trans | State in ^(s->Event.(s.trans))
}


/*
All the states have the same events available.
*/

