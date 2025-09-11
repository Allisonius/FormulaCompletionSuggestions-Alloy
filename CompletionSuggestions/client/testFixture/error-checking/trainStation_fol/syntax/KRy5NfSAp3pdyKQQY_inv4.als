sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv4{

all y : Track | all x : Signal | (x in Entry and x in y.signals) implies all k : track | no k in succs.y
}

