sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv5{

all t1:Tracks | some t2,t3:Tracks | t1 in t2.succs and t1 in t2.succs and t1 != t2 iff t in Junction
}

