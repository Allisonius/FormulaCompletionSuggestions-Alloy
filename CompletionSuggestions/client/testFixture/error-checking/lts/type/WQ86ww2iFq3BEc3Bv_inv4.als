sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	State in {x:State | some (Init.^trans).x}
}

/*
All the states have the same events available.
*/

