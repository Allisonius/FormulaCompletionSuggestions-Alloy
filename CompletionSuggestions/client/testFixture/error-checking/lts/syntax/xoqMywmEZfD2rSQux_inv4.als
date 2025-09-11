sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
     let r = {State->(State.trans.e)| all e: Event} | 
	 		State in Init.^r 
}

/*
All the states have the same events available.
*/

