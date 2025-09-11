sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
	all e:Event| lone e.State.trans
}

/*
All states are reachable from an initial state.
*/

