sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	 Init.Event.*trans in State
}

/*
All the states have the same events available.
*/

