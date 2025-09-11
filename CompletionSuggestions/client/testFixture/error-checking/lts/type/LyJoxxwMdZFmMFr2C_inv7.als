sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv7{
	trans.~trans in iden
}


