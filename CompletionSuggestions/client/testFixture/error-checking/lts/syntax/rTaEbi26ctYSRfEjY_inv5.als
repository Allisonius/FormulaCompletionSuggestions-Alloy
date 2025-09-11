sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv5{
	all s1,s2:State|e:Event | some e.(s1.trans) implies some e.(s2.trans)
}

/*
Each event is available in at least a state.
*/

