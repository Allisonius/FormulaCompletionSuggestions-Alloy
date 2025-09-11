sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv3{


all e : univ | e : Exit iff (all t : univ | t in Track and e->t not in succs)
}

