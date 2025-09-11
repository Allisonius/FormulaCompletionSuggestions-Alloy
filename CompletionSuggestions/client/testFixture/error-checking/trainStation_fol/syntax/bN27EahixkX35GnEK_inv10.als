sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv10{

all t: Tracks, j: Junction | some s: Semaphore| t in j.occurs => s in t.signals

}


