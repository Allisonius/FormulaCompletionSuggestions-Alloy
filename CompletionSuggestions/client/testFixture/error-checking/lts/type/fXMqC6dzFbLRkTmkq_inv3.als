sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv3{ all s,p:State , e:Event | s.trans in e & p.trans in e implies s=p

}

/*
All states are reachable from an initial state.
*/

