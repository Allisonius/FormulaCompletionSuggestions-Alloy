sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv1{
	let r = State->trans | iden in ~r.r
}

/*
There is a single initial state.
*/

