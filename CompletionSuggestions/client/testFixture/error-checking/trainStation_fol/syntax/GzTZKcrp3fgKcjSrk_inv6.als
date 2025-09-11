sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv6{

all entry : Entry | some sinal : Signal | entry->sinal in signals and signal in Speed

}

