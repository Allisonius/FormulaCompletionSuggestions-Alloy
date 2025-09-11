sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	  some (Init.trans)[Event].^trans & iden
}

/*
All the states have the same events available.
*/

