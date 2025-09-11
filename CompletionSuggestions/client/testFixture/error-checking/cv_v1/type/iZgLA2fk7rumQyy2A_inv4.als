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
    all u : User, id : u.profile.ids, w1, w2 : Work | w1->id + w2->id in u.visible => w1 = w2
}



