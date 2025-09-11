sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	States in init.^trans 
}

/*
All the states have the same events available.
*/

