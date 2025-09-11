sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
	all s:State, e:Event | one trans in e->s
}

/*
All states are reachable from an initial state.
*/

