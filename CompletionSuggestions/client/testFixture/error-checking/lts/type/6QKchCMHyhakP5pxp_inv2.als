sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv2{
  lone Init.State
}

/*
The LTS is deterministic, ie, each state has at most a transition for each event.
*/

