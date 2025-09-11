sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
  all x : State, y : Event | lone x.trans.y.State

}

/*
All states are reachable from an initial state.
*/

