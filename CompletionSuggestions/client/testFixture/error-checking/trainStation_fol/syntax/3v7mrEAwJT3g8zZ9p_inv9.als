sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv9{

all t:Tracks, s:Semaphore | t not in succs.Juntion implies no t.Semaphores
}

