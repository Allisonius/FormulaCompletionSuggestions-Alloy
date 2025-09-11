sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv5{
	all s1,s2:State |some e:Event | e.(s1.trans) implies e.(s2.trans)
}

/*
Each event is available in at least a state.
*/

