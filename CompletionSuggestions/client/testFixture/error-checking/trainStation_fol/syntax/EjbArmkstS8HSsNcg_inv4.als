sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv4{

all t1,t2 in Track | t1 != t2 and t2 in t1.succs implies t1 in Entry

}

