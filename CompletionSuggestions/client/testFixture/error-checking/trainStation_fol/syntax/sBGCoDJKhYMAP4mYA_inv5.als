sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv5{

all t:Track | t in Junction iff some disj t1,t2:Track | t1 in t.~succ and t2 in t.~succ
}

