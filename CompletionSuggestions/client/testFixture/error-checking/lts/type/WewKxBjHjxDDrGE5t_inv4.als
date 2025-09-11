sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
  	all s: State | (s in Init) or (some e: Event | trans[e].s) 

}	

/*
All the states have the same events available.
*/

