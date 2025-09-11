sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	all s:State, i:Init | s in State->(i.trans)
}

/*
All the states have the same events available.
*/

