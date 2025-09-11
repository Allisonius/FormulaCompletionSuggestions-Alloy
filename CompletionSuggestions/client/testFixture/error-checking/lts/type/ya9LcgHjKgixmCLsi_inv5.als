sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv5{
	all s : State | Event in s<:trans
}

/*
Each event is available in at least a state.
*/

