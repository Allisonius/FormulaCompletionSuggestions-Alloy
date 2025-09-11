sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv6{


all t:Track | (Entry & t) implies (some s:Speed | s in t.signals)
}

