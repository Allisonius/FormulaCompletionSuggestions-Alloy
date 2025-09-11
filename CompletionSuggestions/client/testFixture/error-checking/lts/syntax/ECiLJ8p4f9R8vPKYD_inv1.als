sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv1{all s : State | some s.tans

}

/*
There is a single initial state.
*/

