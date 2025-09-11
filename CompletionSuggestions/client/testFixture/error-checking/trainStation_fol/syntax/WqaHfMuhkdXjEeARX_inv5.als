sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv5{


all x,y:Track, y:Track-x| x->y in succs and z->y in succs implies y in Junction

}

