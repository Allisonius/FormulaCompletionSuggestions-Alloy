sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	all s : State | let r[x] = x.tran[Event] | s in Init.*r
}

/*
All the states have the same events available.
*/

