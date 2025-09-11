sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
  all s : State | Init.^{x,y : State | x.trans.y} = Evebt
}

/*
All the states have the same events available.
*/

