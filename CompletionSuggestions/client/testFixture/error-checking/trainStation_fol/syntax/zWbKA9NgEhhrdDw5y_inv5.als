sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv5{


all t1:Track | some t2,t3:Track | t1!=t2 and t2!=t3 and t1!=t3 and (t1 in t2.succs and t1 in.succs) implies t1!=t2
}

