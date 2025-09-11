sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv2{

all s : Signal | t,t1 : Track | s in t.signals && s in t1.signals implies t = t1

}

