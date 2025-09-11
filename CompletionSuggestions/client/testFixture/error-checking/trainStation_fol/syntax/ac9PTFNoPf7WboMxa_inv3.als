sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv3{


all ex:Exit | ex in Track => ex in Entry.succs and ex in Juction.succs
}

