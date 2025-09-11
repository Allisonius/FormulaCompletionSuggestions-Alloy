sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	
	let adj = ( all x,y:State | some e:Event | x->e->y in trans )
  	^adj
}

/*
All the states have the same events available.
*/

