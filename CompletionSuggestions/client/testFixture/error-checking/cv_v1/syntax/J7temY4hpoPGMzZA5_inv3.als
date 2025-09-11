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
  all w:Work, w1:Work | w in User.profile && w1 in User.profile -> no (w.ids & w1.ids)

}


