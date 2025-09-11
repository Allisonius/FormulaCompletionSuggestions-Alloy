sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
	all s:s1:s2:State | s->s1 in trans and s->s2 in trans implies s1=s2
}

/*
All states are reachable from an initial state.
*/

