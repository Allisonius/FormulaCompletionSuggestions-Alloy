sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
	all s:State, all e:Event | lone s.trans.e 
}

/*
All states are reachable from an initial state.
*/

