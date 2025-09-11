sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
  all s: State | all e: Event | Init.trans implies e->s in trans
}

/*
All the states have the same events available.
*/

