sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv7{
  all s: Event.(State.trans) | trans.(Event.State) in ^{x,y: State | some x.trans.y}.s
}


