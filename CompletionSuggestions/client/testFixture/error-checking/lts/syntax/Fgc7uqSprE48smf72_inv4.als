sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
  all x : Init, all y : Event | State in *(x.trans).y
}
/*
All the states have the same events available.
*/

