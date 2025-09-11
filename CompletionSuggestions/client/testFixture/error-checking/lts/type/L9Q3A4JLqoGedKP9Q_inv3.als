sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{ lone State.Init

}

/*
All states are reachable from an initial state.
*/

