sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
  all s : State | lone e : Event | s.e.S

}

/*
All states are reachable from an initial state.
*/

