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
  all w1,w2:Work | w1 in visible.(u.profile) and w2 in visible.(u.profile) implies w1=w2
}



