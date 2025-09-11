sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv5{

all j : junction | all t1,t2 : Tracks | t1!=t2 and j in t1.succs&t2.succs





}

