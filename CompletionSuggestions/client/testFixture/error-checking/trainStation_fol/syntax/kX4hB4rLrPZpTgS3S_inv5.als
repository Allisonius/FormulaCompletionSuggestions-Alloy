sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv5{

all disj t1, t2, t3 : Track | t3 in t1.succ and t3 in t2.succ implies t3 = Junction
}

