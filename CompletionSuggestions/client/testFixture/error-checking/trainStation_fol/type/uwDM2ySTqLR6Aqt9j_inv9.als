sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv9{


all t1,t2:Track | t2 in t1.succs and no (Junction & t2) implies Semaphore not in t1.signals
all t1:Track | some (Exit & t1) implies no (Signal in t1)
}

