sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv1{
	all s1, s2:State | some e:Event | (s1->e->s2 in trans and s1 not s2) 
}

/*
There is a single initial state.
*/

