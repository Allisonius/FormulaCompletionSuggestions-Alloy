sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv1{



Track.succs(x) != ? ? Signal.subsetOf(Track.succs(x)) ?
Track.preds(x) != ? ? Signal.subsetOf(Track.preds(x)) ? x : Junction
}

