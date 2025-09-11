sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv9{


all disj t,t2:Track, s:Semaphore | t2 in Junction && t2 not in t.succs && t not in Entry && t not in Exit && t not in specialTrack => s not in t.signals




}

