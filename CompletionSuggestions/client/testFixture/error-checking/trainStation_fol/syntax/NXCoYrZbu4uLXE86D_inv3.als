sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv3{



all tr : Exit and (no tr.succs or (tr in Entry and tr in Junction and tr in tr.succs))
}

