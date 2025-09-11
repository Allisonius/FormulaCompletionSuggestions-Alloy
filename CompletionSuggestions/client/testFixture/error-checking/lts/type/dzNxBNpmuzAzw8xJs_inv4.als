sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	
  	Event.trans.trans.Event
}

/*
All the states have the same events available.
*/

