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

pred inv4{
	all u : User | some w1,  w2 : Work | (some (u<:visible).w1 and (u<:visible).w1) implies w1 = w2
}



