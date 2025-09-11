sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv9{


all t:Track | (all s:t.succs | s in Junction) -> no (s:Semaphore | s in t.signals)
}

