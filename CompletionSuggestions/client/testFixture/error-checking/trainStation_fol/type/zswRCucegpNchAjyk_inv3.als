sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv3{


all t1,t2:Track | t2 in t1.succs implies no (t1 & Exit)
all t1:Track | (t1 & Exit) implies (some t2:Track | t2 in t1.succs)




}

