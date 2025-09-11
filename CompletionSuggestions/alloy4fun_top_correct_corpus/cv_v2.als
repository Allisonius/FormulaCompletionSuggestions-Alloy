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

// The works publicly visible in a curriculum must be part of its profile
pred Inv1 {
    visible in profile
}

// A user profile can only have works added by himself or some external institution
pred Inv2 {
    all u:User| u.profile.source in (u + Institution)
}

// The works added to a profile by a given source cannot have common identifiers
pred Inv3 {
	all s: Source, u: User | all disj w1, w2: (u.profile & source.s) | no w1.ids & w2.ids
}

// The profile of a user cannot have two visible versions of the same work
pred Inv4 {
	all u : User, disj x,y : u.visible | x not in y.^((u.profile <: ids).~(u.profile <: ids))
}