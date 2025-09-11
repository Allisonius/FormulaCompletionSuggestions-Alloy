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
  all s1, s2: Source | s1 == s2 implies  s1.profile.Id not in s2.profile.Id
}


