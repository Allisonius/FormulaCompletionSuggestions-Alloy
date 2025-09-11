sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv10{

all t: Track| all t1: Junction | t1 in t.succs and t1 not Exit => Semaphore in t.signals
}


