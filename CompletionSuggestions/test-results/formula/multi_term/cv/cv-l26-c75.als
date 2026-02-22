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
pred Inv1o {
    all u : User | u.visible in u.profile
}

// A user profile can only have works added by himself or some external institution
pred Inv2o {
    all u : User | u.profile.source in Institution+u
}

// The works added to a profile by a given source cannot have common identifiers
pred Inv3o {
    all u : User, disj x,y : u.profile | x.source = y.source implies no (x.
}

// The p
pred Inv4o {
    all u : User, disj x,y : u.visible | x not in y.^(ids.~ids)
}

// The profile of a user cannot have two visible versions of the same work
pred Inv4_1o {
	all u : User, disj x,y : u.visible | x not in y.^((u.profile <: ids).~(u.profile <: ids))
}