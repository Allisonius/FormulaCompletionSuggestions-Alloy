sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv8{

all disj t1,t2:Track | t in Entry and t2 in Exit implies t2 in t1.^(succs)
}

