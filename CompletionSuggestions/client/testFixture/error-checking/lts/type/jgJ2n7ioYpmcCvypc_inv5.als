sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv5{
  all disj s1, s2: State | all e: Event |some n: State| e->n in s1.trans and e->n in s2.trans implies n.~trans.s1 = n.~trans.s2
}

/*
Each event is available in at least a state.
*/

