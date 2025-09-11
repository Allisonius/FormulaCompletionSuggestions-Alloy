sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv5{

all t : Track | t in Junctions <=> (all p1, p2 : Track| t in p1.succs and t in p2.succs and p1 != p2)
}

