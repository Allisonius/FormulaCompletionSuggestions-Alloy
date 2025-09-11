sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
  
  
  
  
  
 
  no ((States - Init)-(trans.~trans))

}

/*
All the states have the same events available.
*/

