sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv9{



t:Track| some j:Junction | not t->j in succs => (not some s:Semaphore | t->s in signals)
}

