sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv7{
	all t : trans | Init in State.^{x,y : State | some (x.t).y} 
}


