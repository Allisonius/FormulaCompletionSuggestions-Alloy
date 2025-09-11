sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv2{

all t1 : Track | t2: Track | s : Signal | (s in t1.signals) implies (s not in t2.signals)

}

