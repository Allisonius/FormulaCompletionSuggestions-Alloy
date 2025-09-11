sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv5{
  all s1, s2: State | all e: Event |some n: State| e->n in s1.trans & e->n in s2.trans
}

/*
Each event is available in at least a state.
*/

