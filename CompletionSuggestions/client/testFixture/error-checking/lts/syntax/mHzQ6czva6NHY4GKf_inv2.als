sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv2{
	 one s:State | all s2.State | s not in Event.(s2.trans) 
}

/*
The LTS is deterministic, ie, each state has at most a transition for each event.
*/

