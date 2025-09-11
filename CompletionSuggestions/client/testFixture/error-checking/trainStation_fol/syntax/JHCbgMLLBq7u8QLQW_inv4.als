sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv4{

all a:Track| a in Exit implies (some b:Track-b| b->a not in succs)

}

