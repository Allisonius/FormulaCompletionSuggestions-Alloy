sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
  all s1,s2 : State, e : Event |  one s.trans.s
}

/*
All states are reachable from an initial state.
*/

