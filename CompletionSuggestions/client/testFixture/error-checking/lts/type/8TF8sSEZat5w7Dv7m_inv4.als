sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
    Init.*{s1, s2 : State | s1->Event->s2 in trans} = State
}

fun trans_bin : State -> State {
    
}

/*
All the states have the same events available.
*/

