sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv9{


all t : Track | some k : Junction | t->k in succ implies (some s : Semaphore | t->s in signals)


}

