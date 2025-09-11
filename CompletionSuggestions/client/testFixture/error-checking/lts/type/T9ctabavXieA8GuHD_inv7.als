sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv7{
	all s:State | one i:Init | i in (^trans.s)
}


