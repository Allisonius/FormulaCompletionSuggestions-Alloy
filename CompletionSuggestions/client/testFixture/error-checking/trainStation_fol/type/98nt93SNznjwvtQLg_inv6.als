sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv6{

all t:Track,s:Signal | Entry in Track implies one s in t.signals and s in Speed
}

