sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv5{


all t1,t2,t3 : Track | t2!=t3 and t1 in t2.succs&t2.succs <=> t1 in jucntion

}

