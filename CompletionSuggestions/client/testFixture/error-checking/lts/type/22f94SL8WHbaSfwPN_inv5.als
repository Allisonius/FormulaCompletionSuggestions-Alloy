sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv5{
	let t = {x,y : State | some z : Event | x->z->y in trans} |
  	State in t
}

/*
Each event is available in at least a state.
*/

