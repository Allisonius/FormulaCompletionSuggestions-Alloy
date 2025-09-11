sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv5{



all t1:Track | lone (t1 & Track.succs) implies no (Junction & t1)
all t1:Track | no lone (t1 & Track.succs) implies one (Junction & t1)
}

