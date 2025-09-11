sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv3{



all tr : Exit implies (no tr.succs or (tr in Entry and tr in junction and tr in tr.succs)
}

