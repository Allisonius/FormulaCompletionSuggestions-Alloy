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
  all w1 : Work, w2 : Work  | some (w1.ids and w2.ids) implies w1 = w2
}


