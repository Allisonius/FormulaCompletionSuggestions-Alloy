sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv9{



all disj t,t2:Track, s:Semaphore | (t2 in Junction && t2 in t.succs) || t.succs=none -> s not in t.signals
}

