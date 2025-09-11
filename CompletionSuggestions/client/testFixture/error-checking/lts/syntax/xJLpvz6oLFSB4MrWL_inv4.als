sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	let ts : onlyStates[] |
  		all s : State | s in Init.^ts
}

/*
All the states have the same events available.
*/

