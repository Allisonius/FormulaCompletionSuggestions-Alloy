sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv5{

all t, t1, t2: Track | t1 in succs.t && t2.succs.t <=> t in Junction

}

