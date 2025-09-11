sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
	Init + Event.(Init.trans) + Event.((Event.(Init.trans)).trans) + Event.((Event.((Event.(Init.trans)).trans)).trans)
  	
}

/*
All states are reachable from an initial state.
*/

