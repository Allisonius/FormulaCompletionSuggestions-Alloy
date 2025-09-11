sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv1{ lone State.Trans

}

/*
There is a single initial state.
*/

