sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv2{

all s:Signal, t1,t2:Track | s in t1.signals => s not in Track.signals - t
}

