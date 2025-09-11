sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv3{


all t1,t2:Track | t2 in t1.succs implies Exit not in t1
all t1:Track | (Exit & t1) implies (Exit & t1)



}

