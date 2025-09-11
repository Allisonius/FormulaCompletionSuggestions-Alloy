sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv5{
	State in Event.(State<:trans)
}

/*
Each event is available in at least a state.
*/

