sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
  all x : Init, y : State | some (Event.(x.trans)).y 
}

/*
All the states have the same events available.
*/

