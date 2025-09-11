sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv5{

Junctions = Track.{t1,t2 : Track | t1->t2 in succs and no (lone succs.t1)}
}

