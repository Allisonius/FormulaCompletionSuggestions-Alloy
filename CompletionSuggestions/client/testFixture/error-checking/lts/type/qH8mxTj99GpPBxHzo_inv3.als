sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
  all t:trans | lone t
	
}

/*
All states are reachable from an initial state.
*/

