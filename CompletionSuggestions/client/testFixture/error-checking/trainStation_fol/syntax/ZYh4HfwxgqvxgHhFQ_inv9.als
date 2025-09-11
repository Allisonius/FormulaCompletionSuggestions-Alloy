sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv9{

all e : Track | all j : Junction | (not (some j : Junction|j in e.succs) implies (all s : Semaphore | s not in e.signals)
}

