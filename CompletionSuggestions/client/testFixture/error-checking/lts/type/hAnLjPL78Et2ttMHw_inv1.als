sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv1{
	
  	always (State in trans)
}

/*
There is a single initial state.
*/

