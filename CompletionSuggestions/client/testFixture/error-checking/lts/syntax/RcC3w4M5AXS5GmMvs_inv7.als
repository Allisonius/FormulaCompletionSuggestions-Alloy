sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv7{
	all s: State | s in s.^{x, y: State | some (x.trans).y}}
}


