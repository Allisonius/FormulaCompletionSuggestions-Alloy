sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv2{
  all s : State | lone s.Init
}

/*
The LTS is deterministic, ie, each state has at most a transition for each event.
*/

