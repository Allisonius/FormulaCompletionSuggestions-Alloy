sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv3{

all ex:Exit | Track not in ex.succs and ex not in ex.succs and Entry not in ex.succs and Juction not in ex.succs
}

