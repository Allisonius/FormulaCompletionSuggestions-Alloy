sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv5{

all j:Junction | some disj t1, t2:Track | t1 != j and t2 != j and and t1->j in succs and t2->t1 in succs
}

