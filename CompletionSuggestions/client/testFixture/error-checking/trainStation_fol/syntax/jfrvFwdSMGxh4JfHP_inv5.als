sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv5{

all t:Track | (some t1,t2:Track | t1 != t2 t in t1.succs and t in t2.succs) iff t in Junction
}

