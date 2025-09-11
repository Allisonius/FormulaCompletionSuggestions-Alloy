sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv7{
  all s : State | (some ((Init.^trans) :> s)) implies (some ((s.^trans) :> Init))
}


