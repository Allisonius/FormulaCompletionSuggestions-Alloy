sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	 some e:Event, some s:State| Init in ^trans.(e->s)
}

/*
All the states have the same events available.
*/

