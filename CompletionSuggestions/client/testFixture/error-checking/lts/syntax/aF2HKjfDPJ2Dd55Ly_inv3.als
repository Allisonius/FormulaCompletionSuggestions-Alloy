sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
	all s:State | all  e1:Event | e1.(s.trans)=lone
}

/*
All states are reachable from an initial state.
*/

