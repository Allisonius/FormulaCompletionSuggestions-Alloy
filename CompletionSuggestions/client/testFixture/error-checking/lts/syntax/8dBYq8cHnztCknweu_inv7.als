sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv7{
  let adj = {s1,s2: State | some e: Event | s1 -> e -> s2 in trans} |
  all r: Init.^ts | some i: Init | i in r.^adj

}


