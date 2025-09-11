sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv10{

all t1:Track | some t2:Track | t2 in t1.succs and (Junction & t2) implies Semaphore in t1.signals
}


