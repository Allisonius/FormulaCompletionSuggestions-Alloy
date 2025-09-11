sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv7{
	all s : State | s in Init.^reachable {
      some i : Init | i in s.^reachable
    }
}

fun reachable : State -> set State {
	{ s0 : State, s1 : State | s1 in s0.trans[Event] }
}

