sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
    all i : Init, s : State | some i.(*{s1, s2 : State | s1->Event->s2 in trans}).s
}


/*
All the states have the same events available.
*/

