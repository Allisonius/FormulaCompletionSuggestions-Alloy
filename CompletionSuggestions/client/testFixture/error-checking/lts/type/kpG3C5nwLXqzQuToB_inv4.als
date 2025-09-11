sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	all s : State, i:Init, e:Event |  s in i.trans.e.s
}

/*
All the states have the same events available.
*/

