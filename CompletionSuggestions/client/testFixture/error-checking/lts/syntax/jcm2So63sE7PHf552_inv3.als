sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
  all x, z, v : State, y : Event,  | x->y->z in trans and x->y->v in trans implies z=v

}

/*
All states are reachable from an initial state.
*/

