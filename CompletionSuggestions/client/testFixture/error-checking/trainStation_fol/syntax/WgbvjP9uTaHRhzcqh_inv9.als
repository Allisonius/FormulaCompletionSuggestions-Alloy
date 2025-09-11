sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv9{

all e : Track | all j : Junction | e not in j.succs implies (all s : Semaphores | s not in e.signals)
}

