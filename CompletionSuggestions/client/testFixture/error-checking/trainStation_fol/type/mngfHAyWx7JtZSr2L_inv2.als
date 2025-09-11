sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv2{

all t1,t2: Track | no ((t1.signals and t1.succs.^signals) & (t2.signals and t2.succs.^signals))

}

