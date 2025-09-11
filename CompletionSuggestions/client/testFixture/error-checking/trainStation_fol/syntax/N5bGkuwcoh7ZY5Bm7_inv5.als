sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv5{


all t1:Track | some t2,t2:Track | t1!=t2!=t3 implies t1!=t2!=t3
}

