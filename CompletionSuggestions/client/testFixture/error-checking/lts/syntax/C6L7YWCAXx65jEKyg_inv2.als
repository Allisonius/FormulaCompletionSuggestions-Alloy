sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv2{
	all i1,i2 : Initial | i1 = i2
}

/*
The LTS is deterministic, ie, each state has at most a transition for each event.
*/

