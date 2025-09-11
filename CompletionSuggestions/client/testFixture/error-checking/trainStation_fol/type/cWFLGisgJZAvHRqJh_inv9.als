sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv9{

all t : Track | all j : Junction | all s : Semaphore | no j in t.succs implies s not in t.signals
}

