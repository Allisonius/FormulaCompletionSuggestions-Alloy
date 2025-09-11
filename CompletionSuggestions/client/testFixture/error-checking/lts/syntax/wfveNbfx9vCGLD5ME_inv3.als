sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
	all s:State,e:event | lone e.(s.trans)
}

/*
All states are reachable from an initial state.
*/

