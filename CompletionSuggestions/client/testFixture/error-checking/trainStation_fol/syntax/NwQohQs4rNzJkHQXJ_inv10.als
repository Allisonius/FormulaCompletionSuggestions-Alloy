sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv10{


all t:Junction, x:Track| some s:Semaphore| j in x.succs implies x->s in signals

}


