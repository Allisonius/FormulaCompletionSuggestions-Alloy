sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
  all s : State -> lone s.trans.Event
}

/*
All states are reachable from an initial state.
*/

