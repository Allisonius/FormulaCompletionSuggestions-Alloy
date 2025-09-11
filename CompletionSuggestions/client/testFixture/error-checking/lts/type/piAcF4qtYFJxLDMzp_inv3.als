sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{ all s,p:State | s.trans in Event & p.trans in Event implies s=p

}

/*
All states are reachable from an initial state.
*/

