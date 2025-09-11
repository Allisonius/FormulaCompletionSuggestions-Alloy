sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv8{

all t: Track | (t.succs = Junction + Entry + Exit) => (t.signals & Semaphore = {})
}

