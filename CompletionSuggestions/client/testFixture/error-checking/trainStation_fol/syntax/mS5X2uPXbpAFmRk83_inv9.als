sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv9{

MAL !!! all t:Track, s:Semaphore | s not in t.signals iff (some j:Junction | j not in t.succs)

}

