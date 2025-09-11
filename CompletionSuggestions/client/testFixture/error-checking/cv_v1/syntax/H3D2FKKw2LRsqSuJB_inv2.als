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
	all u : User | u.profile.source in Institution + u
}


aux = {u, User, w : Work, s : Source | u -> w in profile and w -> s in source}


