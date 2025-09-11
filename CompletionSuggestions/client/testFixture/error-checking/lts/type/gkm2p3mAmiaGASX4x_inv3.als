sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
	all s: State |one e: Event | lone s->e in State
}

/*
All states are reachable from an initial state.
*/

