sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv1{
    trans.State = State
}

/*
There is a single initial state.
*/

