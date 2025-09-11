sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv7{
  some s: State | s in s.^trans.State.Event = Init
}


