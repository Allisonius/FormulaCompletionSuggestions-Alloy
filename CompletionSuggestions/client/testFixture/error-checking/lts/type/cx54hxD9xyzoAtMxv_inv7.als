sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv7{
	(Event.(State.trans)).~(Event.(State.trans)) in iden
}


