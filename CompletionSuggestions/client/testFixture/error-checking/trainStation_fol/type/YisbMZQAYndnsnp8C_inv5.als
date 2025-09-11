sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv5{

all disj t,t2,t3:Track | t in Junction <=> some t in Track.^(succs)
}

