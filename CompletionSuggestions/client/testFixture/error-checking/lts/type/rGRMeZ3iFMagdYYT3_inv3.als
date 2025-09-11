sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
  all e : Event | State in trans.e
}

/*
All states are reachable from an initial state.
*/

