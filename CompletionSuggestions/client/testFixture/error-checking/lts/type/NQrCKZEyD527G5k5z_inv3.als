sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
   	~trans.trans in trans->trans
}

/*
All states are reachable from an initial state.
*/

