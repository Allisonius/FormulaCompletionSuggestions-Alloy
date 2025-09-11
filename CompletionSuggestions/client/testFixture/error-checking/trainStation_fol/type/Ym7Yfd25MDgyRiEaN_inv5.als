sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv5{

all t1,t2,t3 : Track | t2!=t3 and t1!=t2 and t1 in t2.succs&t2.succs implies t1 in Junction
all t1 : Track | lone t1 in Track.succs implies t1 not in Junction
}

