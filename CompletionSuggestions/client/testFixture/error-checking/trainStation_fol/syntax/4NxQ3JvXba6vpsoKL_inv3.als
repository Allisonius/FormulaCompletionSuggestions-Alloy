sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv3{

all ex:Exit | ex not in Juction and ex not in Entry => no ex.^(succs) and ex not in ex.^(succs)
}

