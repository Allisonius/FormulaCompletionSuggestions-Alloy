sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv5{

all t : Track |  ((some s : Track | t in s.succs) and (some u : Track | t in u.succs) and s!=u) iff t is Junction
}

