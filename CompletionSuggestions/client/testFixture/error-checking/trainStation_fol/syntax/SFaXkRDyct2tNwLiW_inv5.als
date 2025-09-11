sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv5{

all t:Track | t in Junction <=> t in t2.^(succs) and t in t3.^(succs)

}

