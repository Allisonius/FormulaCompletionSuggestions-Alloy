sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv5{

all j:Junction | disj some t1, t2:Track | t1->j in succs and t2->t1 in succs
}

