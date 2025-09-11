sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv9{


all t,k : Track | t->k in succ and t in Junction implies (some y : Semaphore | k->s in signals)


}

