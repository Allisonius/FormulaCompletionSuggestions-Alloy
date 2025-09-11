sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	all s: State.trans.Event | s.^{y,x: State | some x.trans.y} = Initial
}

/*
All the states have the same events available.
*/

