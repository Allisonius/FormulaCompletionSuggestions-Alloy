sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
    Init.*trans_bin = State
}

fun trans_bin : State -> State {
    {s1:Book, s2:Addr | s1->Event->s2 in trans }
}

/*
All the states have the same events available.
*/

