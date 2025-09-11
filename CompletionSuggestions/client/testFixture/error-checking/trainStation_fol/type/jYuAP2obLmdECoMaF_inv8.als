sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv8{

all t: Track | t in Exit implies all t1: Track | t1 in Entry and t1.^(succs)
}

