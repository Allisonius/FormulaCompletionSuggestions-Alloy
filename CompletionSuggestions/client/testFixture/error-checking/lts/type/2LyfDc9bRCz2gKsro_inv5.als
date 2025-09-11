sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv5{
	Event in Event -> State
}

/*
Each event is available in at least a state.
*/

