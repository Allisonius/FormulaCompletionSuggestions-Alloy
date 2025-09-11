sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	all s: State | Init.^function
}

/*
All the states have the same events available.
*/
fun function: State->State {
  {s1, s2: State | s1->Event->s2 in trans}
}

