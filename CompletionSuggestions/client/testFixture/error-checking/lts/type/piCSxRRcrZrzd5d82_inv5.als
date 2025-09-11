sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv5{
  all s1,s2 : State | no ((s1.Event)-(s2.Event))

}

/*
Each event is available in at least a state.
*/

