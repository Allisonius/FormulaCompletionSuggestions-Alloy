sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv5{


some x,y:Track|all z:Track| x->y in succs and z->y in succs and x not y implies y in Junction

}

