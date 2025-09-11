sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv9{

all t : Track | no t.succs implies no t.signals&Semaphore
all t : Track | no t.succs&Junction implies no t1.signals&Semaphore
}

