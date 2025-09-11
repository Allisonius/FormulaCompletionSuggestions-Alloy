sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
	all s: State | some (*{s1, s2: State | some (s2 <: trans :> s1}.s & Init)
}

/*
All the states have the same events available.
*/

