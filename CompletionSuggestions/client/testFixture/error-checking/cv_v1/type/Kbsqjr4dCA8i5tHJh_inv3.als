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

pred inv3{
	all disj w1,w2:Work, u:User | w1 and w2 in u.profile implies no (w1.ids & w2.ids)
}


