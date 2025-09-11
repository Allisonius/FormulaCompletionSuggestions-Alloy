sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	Init.*{s1, s2: State | s1.trans.s2} = State
}

/*
All the states have the same events available.
*/

