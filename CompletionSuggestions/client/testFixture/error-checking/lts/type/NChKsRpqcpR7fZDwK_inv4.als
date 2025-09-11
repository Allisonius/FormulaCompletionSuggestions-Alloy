sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
  let t = { all x,y : State | some z : Event | x->z->y in trans} | State in Init.(^t)
}

/*
All the states have the same events available.
*/

