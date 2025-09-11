sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	all e : Event | State = Init + (e.(^Init.trans))
  }

/*
All the states have the same events available.
*/

