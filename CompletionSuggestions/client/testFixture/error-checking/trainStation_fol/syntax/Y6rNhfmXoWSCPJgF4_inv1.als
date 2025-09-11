sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv1{

all t : Track, en : Entry, ex : Exit | some en in t.succs && some ex in t.succs

