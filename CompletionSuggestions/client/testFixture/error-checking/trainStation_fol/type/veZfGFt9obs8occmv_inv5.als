sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv5{



all t1,t2:Track | t1 in t2.succs and t1 not in ((Track-t1)-t2).succs implies no (Junction & t1)
all t1:Track | (Entry & t1) implies no (Junction & t1)


}

