sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	State in Init.trans
}

/*
All the states have the same events available.
*/

