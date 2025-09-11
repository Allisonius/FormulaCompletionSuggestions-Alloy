sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv3{

all t:Exit | all ts:Track, s:Signal, ss:Semaphore, sss:Speed | t!=ts and t->ts not in succs and t->s not in signals and
}

