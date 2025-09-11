sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv7{
	all i: Init, r : (i.^function) | some i in r.^function
}

fun function: State->State {
  
  {s1, s2: State | some (s1.trans).s2}
}


