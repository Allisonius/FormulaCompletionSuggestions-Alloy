sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{ Init.^adj

}

/*
All the states have the same events available.
*/
fun adj: State -> State {
{ x,y : State | some (x.trans).y }  
}

