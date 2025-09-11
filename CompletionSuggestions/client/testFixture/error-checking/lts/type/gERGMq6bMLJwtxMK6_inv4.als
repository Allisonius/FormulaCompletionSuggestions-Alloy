sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
     let r = all e: Event | State->(State.trans.e) | 
	 		State in Init.^r 
}

/*
All the states have the same events available.
*/

