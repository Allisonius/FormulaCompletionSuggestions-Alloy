sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv9{

all t1,t2:Track | t1 in Entry && t2 in Exit && t1 != t2 implies t2 in t1.^(succs)
}



}

