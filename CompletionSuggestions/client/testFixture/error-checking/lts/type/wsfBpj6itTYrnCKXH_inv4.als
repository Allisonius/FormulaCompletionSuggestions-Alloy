sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	all s: State | State in Event.(s.*trans)
}

/*
All the states have the same events available.
*/

