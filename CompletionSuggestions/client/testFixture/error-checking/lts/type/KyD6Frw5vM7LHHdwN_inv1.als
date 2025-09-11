sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv1{
	all s: State | some e: State | s.Event = e
}

/*
There is a single initial state.
*/

