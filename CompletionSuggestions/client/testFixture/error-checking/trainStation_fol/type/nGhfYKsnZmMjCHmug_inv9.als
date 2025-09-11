sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv9{


all t:Track, s:Semaphore | t not in Junction and t.succs.Junction = none => s not in t.signals
}

