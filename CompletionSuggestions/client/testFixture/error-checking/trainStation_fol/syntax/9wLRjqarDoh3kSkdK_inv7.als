sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv7{

all t:Track | t in Exit => not in Entry
all t:Track | t in Entry => not in Exit
}

