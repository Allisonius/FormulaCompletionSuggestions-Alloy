sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv5{
	all s:State, e:Events | some e.(s.trans)
}

