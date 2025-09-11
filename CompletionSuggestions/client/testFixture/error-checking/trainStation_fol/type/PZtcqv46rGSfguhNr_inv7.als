sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv7{

all x1,x2 : Track | x1 in x2.succs implies x1 x2 not in x1.^succs
}

