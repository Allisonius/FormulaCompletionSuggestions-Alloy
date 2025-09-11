sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv9{



all t:Track | no (Junction & t.succs) implies no (Junction & t.succs)



all t1:Track | one (Exit & t) implies (some s:Semaphore | s not in t.signals)
}

