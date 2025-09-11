sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv10{


all a,b:Track, s:Semaphore| b in Junction and b->a in succs implies a->s in signal

}


