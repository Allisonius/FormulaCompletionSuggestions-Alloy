sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
  let adj = {s1,s2: State | some e s1.e.s2}
  all s: State | some i: Init | s in ^adj
}

/*
All the states have the same events available.
*/

