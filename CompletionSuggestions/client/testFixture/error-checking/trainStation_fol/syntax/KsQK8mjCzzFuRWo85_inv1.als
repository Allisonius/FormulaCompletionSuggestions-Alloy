sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv1{

all t: Track | some en : Entry | some ex : Exit | en in t1.succs and ex in t1.succs
}

