sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv1{
	~trans.trans in iden
}

/*
There is a single initial state.
*/

