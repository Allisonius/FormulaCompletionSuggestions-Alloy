sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv7{
	all s:State | s in Event.(trans.State) implies s in Event.(State.^trans)
}


