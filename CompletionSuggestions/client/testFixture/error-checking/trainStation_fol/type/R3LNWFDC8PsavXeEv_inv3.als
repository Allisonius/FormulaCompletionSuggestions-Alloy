sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv3{

all t: Track| #t.succs=0 implies t in Exit
all t: Exit | no t in Entry
}

