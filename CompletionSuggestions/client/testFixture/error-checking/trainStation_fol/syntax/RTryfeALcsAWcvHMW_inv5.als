sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv5{

all t : Track| some j: Junction |some s,u : Track | ((t in s.succs) and (t in u.succs) and s!=u) iff (t ==j)
}

