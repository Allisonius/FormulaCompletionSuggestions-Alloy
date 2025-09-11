sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv7{
  let t = {x: State, y: State | some (x.trans).y };
  Init in Init.^t
}


