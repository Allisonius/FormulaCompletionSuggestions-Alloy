sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
	all s1,s2:State, e:Event | lone  (s1->e->s2) in trans
}

/*
All states are reachable from an initial state.
*/

