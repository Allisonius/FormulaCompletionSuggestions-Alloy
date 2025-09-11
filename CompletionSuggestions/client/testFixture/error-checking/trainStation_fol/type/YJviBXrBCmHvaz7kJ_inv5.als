sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv5{

all t:Track | (some p1,p2:Track | p1 != p2 and p1 in t & Track.succs and p2 in p2 in t & Track.succs) iff t in Junction
}

