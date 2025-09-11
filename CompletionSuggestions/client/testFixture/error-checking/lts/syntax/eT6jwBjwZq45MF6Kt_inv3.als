sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
  all s:State, all e:Event | lone e->s in s.trans
	
}

/*
All states are reachable from an initial state.
*/

