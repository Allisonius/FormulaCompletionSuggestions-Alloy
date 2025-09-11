sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv5{
	all s,s1:State,e:Event | s->e in trans
}

/*
Each event is available in at least a state.
*/

