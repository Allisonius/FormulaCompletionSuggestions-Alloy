sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv7{
	all n : State-Init | Init in State.^trans.n
}


