sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv7{
  all e : Event | some e.(Init.trans) implies e.~(Init.trans)
}


