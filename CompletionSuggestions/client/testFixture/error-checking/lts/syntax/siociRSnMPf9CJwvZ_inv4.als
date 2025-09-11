sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	all s : State | s in Init.*tran1
}

/*
All the states have the same events available.
*/
fun tran1 (s : State) : set State {
  s.trans[Event]
}

