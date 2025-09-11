sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
all s : State, e | ~(s.trans).(s.trans) in iden 
}

/*
All states are reachable from an initial state.
*/

