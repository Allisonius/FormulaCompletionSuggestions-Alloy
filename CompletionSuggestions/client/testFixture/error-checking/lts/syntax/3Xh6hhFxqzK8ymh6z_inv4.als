sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
  
  no Init  implies no State and (some e:Event | all s:(State-Init) | some(Init & trans^.(e->s)) )
}

/*
All the states have the same events available.
*/

