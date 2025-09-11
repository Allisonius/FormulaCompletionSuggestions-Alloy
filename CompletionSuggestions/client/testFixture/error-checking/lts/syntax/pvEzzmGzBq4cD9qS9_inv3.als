sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{ all s : State , e : Event | lone e.(s.trans) 

}

fun adj: State -> State {
  {x,y : State | some (x.trans).y }
/*
All states are reachable from an initial state.
*/

