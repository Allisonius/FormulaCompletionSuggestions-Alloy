sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv8{

all disj t,t1:Track | t in Entry and t1 in Exit implies t1 in t^.succs

}

