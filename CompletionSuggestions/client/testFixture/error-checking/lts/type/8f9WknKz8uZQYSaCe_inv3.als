sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
	
  	all e:Event |some s:State | lone e.(s.trans) in State 
}

/*
All states are reachable from an initial state.
*/

