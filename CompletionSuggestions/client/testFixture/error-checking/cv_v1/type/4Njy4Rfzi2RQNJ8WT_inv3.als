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
  all s1, s2: Source | all w1, w2: Work| s1.profile.w1 and s2.profile.w2 and s1= s2 implies  w1.ids not in w2.ids
}


