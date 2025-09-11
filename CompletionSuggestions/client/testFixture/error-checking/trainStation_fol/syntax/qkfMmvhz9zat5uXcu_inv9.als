sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv9{

all t : Tracks | all j : Junction | all s : Semaphore | j not in t.succs implies no s in t.signals
}

