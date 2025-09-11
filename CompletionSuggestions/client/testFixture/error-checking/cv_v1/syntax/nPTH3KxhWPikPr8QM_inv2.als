abstract sig Source {}
sig User extends Source {
    profile : set Work,
    visible : set Work
}
sig Institution extends Source {}

sig Id {}
sig Work {
    ids : some Id,
    source : one Source
}

pred inv2{
	all w1, w2:Work, u:User, i:Institution | w1, w2 in u.profile implies (u in w1.source and i in w2.source)
}


