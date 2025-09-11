sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv1{


all x : Track | some y : Entry | some z : Exit | y->x in succs and x->z in succs

