sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
  all x : Init, y : State | Node x.*(trans.Event)

/*
All the states have the same events available.
*/

