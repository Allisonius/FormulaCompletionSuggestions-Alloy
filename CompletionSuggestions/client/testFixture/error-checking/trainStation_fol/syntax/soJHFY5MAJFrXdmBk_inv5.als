sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv5{

all t1,t2,t3: Track| t1 in t2.succs and t1 in t3.succs <=> t in Junction
}

