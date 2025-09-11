sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv7{
  all s: Event.(State.trans) | Init in (s.~trans).Event
}


