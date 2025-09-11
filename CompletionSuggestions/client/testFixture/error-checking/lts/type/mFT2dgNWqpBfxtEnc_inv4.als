sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
  all s: State | all e: Event | Init.trans in trans implies e->s
}

/*
All the states have the same events available.
*/

