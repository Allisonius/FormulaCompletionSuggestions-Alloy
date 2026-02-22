sig Person  {
  Tutors : set Person,
  Teaches : set Class
}

sig Group {}

sig Class  {
  // this is in ternary relation
  Groups : Person -> Group
}

sig Teacher in Person  {}

sig Student in 