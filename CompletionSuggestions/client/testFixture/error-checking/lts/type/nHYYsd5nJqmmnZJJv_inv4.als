sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	all s:State, s1:State,e:Event, t:trans | s->e in s.trans 
}

/*
All the states have the same events available.
*/

