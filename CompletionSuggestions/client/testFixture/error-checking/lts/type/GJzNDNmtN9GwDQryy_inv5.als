sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv5{
  all s1,s2 : State | no ((Event.s1)-(Event.s2))

}

/*
Each event is available in at least a state.
*/

