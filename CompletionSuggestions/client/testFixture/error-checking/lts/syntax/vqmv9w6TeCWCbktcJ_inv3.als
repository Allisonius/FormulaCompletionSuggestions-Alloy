sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
	all s : State, e : Event | lone e.(s.trans)  
}

adj = {x,y : State | some e : Event | x -> e -> y in trans}

/*
All states are reachable from an initial state.
*/

