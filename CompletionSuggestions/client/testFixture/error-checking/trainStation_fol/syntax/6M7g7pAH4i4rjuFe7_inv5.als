sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv5{

all j : Junction | t not in Track.succs implies t in Entry
all e : Entry | e not in Track.succs
}

