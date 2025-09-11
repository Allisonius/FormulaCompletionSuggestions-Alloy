sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv7{
    let trans2 = {s1, s2 : State | some s1.trans.s2} |
    Init in (Init.^trans2 + (Init->Init))
}


