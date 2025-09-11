sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	all i : Init | Event.(i.trans) 
}

/*
All the states have the same events available.
*/

