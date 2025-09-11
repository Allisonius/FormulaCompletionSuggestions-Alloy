sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv3{





all a:Track | a in Exit implies all a2:Track | a->a2 not in succs
all a:Track | all a2:Track | a->a2 not in succs implies a in Exit iff
}

