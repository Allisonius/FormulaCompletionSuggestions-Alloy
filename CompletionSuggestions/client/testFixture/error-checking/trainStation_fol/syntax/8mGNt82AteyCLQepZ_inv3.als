sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv3{

all t: Track | #(succ.t)=0 implies t in Entry
all t: Track |  t in Entry implies #(succ.t)=0

}

