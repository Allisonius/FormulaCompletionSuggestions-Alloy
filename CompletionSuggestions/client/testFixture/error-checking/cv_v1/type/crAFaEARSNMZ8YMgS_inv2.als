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
	all u : User | some w : Work | u->w in profile implies (w->source in Institution or w->source in User)
}


