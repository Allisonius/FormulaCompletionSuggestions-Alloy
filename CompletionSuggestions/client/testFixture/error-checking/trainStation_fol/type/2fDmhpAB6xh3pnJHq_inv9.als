sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv9{




all t:Track | not some Junction in t.succs => (not some s:Semaphore | t->s in signals)
}

