sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv9{

all j : Junction | all t : Track | all s : Semaphore j not in t.succs implies s not in t.signals
}

