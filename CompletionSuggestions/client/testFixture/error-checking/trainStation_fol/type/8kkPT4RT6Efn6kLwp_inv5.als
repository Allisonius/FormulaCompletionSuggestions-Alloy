sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv5{

all t: Track | some t1, t2: Track | t in t1.succs && t in t2.succs && t1!=t2!=t <=> t in Junction
}

