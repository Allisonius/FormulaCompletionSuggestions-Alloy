sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
  all s1, s2 : State , e : Event | (s1 in Init) implies (s2 in (s1.e.^trans)) 

}

/*
All the states have the same events available.
*/

