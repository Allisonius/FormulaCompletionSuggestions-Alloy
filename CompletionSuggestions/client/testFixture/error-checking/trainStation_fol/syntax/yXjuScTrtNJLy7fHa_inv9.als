sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv9{

all t: Track | some x: Junction | no (t.succ & Junction) <=> no (t.signals & Speed)

}

