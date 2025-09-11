sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	let x = Init <: trans | State in ~(Event.(State.trans))
}


/*
All the states have the same events available.
*/

