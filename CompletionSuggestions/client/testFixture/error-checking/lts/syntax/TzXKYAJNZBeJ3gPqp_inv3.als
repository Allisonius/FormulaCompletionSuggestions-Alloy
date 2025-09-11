sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
  all s : State, e : Event | lone s.trans[e]
}

fun tr : State -> State { { s1, s2 : State | s1->Event->s2 in trans }

/*
All states are reachable from an initial state.
*/

