sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv5{

all x: Junctions | some a,b: Tracks | x in (a.succs and x in b.succs)
}

