sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv7{
  fun edge : State -> State {
    s1, s2: State | some s1.trans.s2
  }

  all s: State | s in Init.^edge implies some (Init & s.^edge)
}


