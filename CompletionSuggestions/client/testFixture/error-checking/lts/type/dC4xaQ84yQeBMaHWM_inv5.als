sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv5{
	{state: State, event: Event | some event.(state.trans)}.~{state: State, event: Event | some event.(state.trans)} = univ
}

/*
Each event is available in at least a state.
*/

