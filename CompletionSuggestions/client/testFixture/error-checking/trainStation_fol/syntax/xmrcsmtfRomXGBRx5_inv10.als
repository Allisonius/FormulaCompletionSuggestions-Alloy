sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv10{
all x:Junction | some z:Semaphore | all y:Tracks | x in y.succs implies z in y.signals


}

