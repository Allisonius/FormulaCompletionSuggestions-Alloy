sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv8{

all t1,t2:Track  -> t1!=t2 |  t1 in Entry && t2 in Exit implies t2 in t1.^(succs)

}

