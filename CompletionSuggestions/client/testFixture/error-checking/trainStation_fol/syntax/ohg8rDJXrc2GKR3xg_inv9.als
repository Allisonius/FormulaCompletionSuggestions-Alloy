sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv9{


all m : Message | (m in User.inbox) implies (m in Undelivered since send[m.from,m.to,m.content])
}

