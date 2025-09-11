sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv1{

all t:Track, e:Entry, ex:Exit | #e in t.succs >=1 and #ex in t.succs >=1

}

