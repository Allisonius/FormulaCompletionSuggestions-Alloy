sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv4{

all t1 : Track | all t2 : Track | (no t1 in t2.succs) iff t1 in Entry

}

