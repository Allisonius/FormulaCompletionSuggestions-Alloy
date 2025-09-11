sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv1{
	let k = trans.State | iden{State} in ~k.k
}

/*
There is a single initial state.
*/

