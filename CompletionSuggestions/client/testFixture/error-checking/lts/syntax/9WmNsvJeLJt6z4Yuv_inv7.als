sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv7{
  some i: Initial, r: Event.State.trans | i in r.^trans

}


