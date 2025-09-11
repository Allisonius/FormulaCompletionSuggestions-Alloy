sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv2{

all x,y: Track, s: Signal | signals(x,s) and signals(y,s) implies x=y

}

