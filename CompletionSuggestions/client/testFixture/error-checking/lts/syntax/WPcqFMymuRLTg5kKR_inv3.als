sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
	all e:event, s:State | lone e
}

/*
All states are reachable from an initial state.
*/

