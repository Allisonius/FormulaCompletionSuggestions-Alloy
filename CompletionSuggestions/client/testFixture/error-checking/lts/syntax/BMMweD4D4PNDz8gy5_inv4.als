sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
    Initial.{s1 : State, s2 : State | s1->Event->s2 in trans} = State
}


/*
All the states have the same events available.
*/

