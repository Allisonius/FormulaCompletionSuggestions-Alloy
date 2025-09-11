sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv6{


all  x:Tracks, y:Signal| x in Entry implies x->y in signals and y in Speed
}

