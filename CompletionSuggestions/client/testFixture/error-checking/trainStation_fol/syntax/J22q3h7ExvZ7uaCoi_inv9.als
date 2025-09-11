sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv9{


all a,b:Track|b in Junction and b->a in succs implies all s:Semaphores| a->s in signals

}

