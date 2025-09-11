sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
  State in Init.(^onlyStates)
}

fun onlyStates : set State -> State {
  s1,s2: State | some e: Event | s1->e->s2 in trans
}

/*
All the states have the same events available.
*/

