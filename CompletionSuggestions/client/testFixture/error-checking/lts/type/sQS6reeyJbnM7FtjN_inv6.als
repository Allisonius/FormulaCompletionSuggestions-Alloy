sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv6{
  Event = trans.State
}

/*
The LTS is reversible, ie, from a reacheable state it is always possible 
to return to an initial state.
*/

