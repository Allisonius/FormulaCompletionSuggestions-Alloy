sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
  let t = { x : State, y : State | some e : Event | x->e->y in trans} |
  all u : State | some Init in u.(^t)
}
/*
All the states have the same events available.
*/

