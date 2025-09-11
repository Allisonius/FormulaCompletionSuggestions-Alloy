sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv5{
	{x,y: State | Event in x.(trans.y)} 
}

/*
Each event is available in at least a state.
*/

