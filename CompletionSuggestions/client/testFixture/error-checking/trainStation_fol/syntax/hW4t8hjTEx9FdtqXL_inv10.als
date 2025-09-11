sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv10{

all x1 : Track | all y : Junction | some z : Semaphore | y in x.^succs implies z in x.signals
}


