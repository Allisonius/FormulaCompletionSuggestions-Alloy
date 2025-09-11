sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv1{


some t1 :Track| one t2: Track | t1 in Entry and t1 not int Exit and t2 in Exit and t2 not in Entry
}

