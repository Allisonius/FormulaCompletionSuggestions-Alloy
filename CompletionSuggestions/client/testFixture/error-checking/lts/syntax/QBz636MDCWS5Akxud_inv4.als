sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	one Init
}

fun f[t : trans] : State->State {
	{s1->s2 : State->State | s1 in trans.univ and s2 in univ.trans}
}

/*
All the states have the same events available.
*/

