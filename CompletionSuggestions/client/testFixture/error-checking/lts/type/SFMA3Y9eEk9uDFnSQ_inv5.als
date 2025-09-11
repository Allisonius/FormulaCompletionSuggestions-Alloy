sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv5{
	all x : State | some (x.Event.State)
}
/*
Each event is available in at least a state.
*/

