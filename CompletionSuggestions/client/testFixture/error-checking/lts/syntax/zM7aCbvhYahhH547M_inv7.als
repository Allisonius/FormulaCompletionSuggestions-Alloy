sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv7{all s: in Init.^adj | some s.^adj & Init

}


