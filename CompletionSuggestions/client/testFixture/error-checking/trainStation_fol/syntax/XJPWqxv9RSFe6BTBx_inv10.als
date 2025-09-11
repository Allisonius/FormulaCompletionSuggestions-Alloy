sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv10{

all f:Track, j:Junction, s:Semaphore| j in f.sucss implies f-> s in signals

}


