sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv6{
	all e:Event |some s,s1:State | some (s1->e->s) in trans
}

/*
The LTS is reversible, ie, from a reacheable state it is always possible 
to return to an initial state.
*/

