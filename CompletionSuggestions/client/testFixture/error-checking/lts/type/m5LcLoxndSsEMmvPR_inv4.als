sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
 some e: Event | Init.trans implies *trans.e
}

/*
All the states have the same events available.
*/

