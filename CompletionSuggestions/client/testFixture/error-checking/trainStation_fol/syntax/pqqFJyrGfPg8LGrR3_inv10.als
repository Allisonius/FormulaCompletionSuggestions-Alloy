sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv10{

all t : Tracks | all j : Junction | t in j.succs implies (some s : Semaphore | s in t.signals)

}


