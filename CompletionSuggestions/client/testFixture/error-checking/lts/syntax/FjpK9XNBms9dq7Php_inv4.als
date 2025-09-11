sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
  ((init.trans)^[Event]).trans[Event]
}

/*
All the states have the same events available.
*/

