sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv3{


all e : Exit | all t : Track | all s : Signals | e->t not in succs and e->s not in signals

}

