sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv3{


all t : Track , all t1 : Track - {t} | t in Exit implies t1 not in t.succs
}

