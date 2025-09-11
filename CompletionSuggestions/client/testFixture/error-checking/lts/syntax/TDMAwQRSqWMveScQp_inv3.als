sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{
all s: state | set f : Event | lone n: State | f->n in s.trans
}

/*
All states are reachable from an initial state.
*/

