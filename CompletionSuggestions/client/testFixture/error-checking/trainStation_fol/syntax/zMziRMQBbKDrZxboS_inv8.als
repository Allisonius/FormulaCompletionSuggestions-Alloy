sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv8{


all t1,t2:Track | one (t1 & Entry) and one (t2 & Exit) implies t1 in t2.^succs or (t1==t2)
}

