sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	all s:State, i:Init |  some (i.^trans :> s )
}

/*
All the states have the same events available.
*/

