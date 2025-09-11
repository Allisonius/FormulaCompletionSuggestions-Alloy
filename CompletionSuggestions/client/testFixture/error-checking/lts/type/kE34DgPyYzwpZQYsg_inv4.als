sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	all s:State | some e:Event | s in ^e.(Init.trans)
}

/*
All the states have the same events available.
*/

