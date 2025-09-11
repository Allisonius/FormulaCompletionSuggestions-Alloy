sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv1{
  all s: State | some x.trans
}

/*
There is a single initial state.
*/

