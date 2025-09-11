sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	some r1: State->Event | some r2: Event->State | r1.Event->r2 = trans && State in Init.^(r1.r2)

}

/*
All the states have the same events available.
*/

