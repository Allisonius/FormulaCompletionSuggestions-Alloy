sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
    let trans_bin = {s1 : State, s2 : State | some s1.trans.s2}
    Init.*trans_bin = State
}


/*
All the states have the same events available.
*/

