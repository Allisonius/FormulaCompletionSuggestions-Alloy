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
all w1, w2 : Work | all u : User | w1.ids == w2.ids and (w1 + w2) in u.visible and (w1 + w2) in u.profile implies w1.source = w2.source 
}



