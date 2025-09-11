sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv7{
  let ss = {x : State | some Init.trans.x} {
   		ss = ~ss 
  }
}


