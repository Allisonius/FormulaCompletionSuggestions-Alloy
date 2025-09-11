sig Room {}
one sig secure_lab extends Room {}

abstract sig Person {
  owns : set Key
}
sig Employee extends 
sig Researcher extends Person {}

sig Key {
  authorized: one Employee,
  opened_by: one Room
}