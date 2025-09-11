sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv2{

all t1, t2: Tracks,
s: Signal |
((s in t1.(^succs.signals)) and (s in t2.(^succs.signals)) implies t1 = t2

}

