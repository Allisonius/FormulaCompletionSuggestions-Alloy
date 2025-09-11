sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
	let k = ~trans.State | k.~k in iden
}

/*
All states are reachable from an initial state.
*/

