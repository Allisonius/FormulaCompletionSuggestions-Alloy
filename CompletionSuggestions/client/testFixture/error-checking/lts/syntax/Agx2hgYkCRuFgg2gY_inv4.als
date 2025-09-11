sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{ 
  all u : Init | Node in  u.*{ x : State, y : State | x->Event->y in trans}  
}
/*
All the states have the same events available.
*/

