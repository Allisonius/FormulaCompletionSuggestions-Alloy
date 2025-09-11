sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv1{

all j:Junction | some e:Entry, x:Exit | e!=j and j!=x implies e->j in Track and j->x in Track
}

