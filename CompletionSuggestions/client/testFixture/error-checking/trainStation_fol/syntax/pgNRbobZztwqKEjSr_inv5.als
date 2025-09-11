sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv5{

all j : Junction | #(succs.j) > 2
all t : Track | #(succs.j) > 2 implies t in Junction
}

