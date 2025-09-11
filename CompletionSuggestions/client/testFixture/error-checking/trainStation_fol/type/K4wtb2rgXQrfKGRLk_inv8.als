sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv8{

all en : Entry | en.^succs&Exit
no Signal
no Semaphore
no Speed
}

