sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
	
  	
  	all s,s1:State,e:Event | lone s->e->s1 in trans
}

/*
All states are reachable from an initial state.
*/

