sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv1{
	
  	let s = State <: trans | s.~s in iden 
}

/*
There is a single initial state.
*/

