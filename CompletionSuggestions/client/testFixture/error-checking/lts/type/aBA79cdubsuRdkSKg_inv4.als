sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
 some e: Event | all s: State | Init.trans implies s
}

/*
All the states have the same events available.
*/

