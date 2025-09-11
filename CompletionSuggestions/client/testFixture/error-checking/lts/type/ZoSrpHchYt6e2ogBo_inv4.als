sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
  Event.Init.trans = State
}

/*
All the states have the same events available.
*/

