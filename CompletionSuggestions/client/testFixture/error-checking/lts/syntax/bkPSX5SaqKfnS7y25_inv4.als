sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	all s1,s2 : State | some e : Event | s1->e->s2  in trans
  	State in Init.(^( s1,s2 : State | some e : Event | s1->e->s2  in trans))
}

/*
All the states have the same events available.
*/

