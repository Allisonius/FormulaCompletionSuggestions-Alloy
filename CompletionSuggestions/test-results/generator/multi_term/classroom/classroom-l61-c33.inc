sig Person  {
  Tutors : set Person,
  Teaches : set Class
}

sig Group {}

sig Class  {
  Groups : Person -> Group
}

sig Teacher in Person {}

sig Student in Person  {}

pred inv1o {
  Person in Student
}

pred inv2o {
  no Teacher
}

pred inv3o {
  no Student & Teacher
}

pred inv4o {
  Person in Student + Teacher
}

pred inv5o {
  some Teacher.Teaches
}

pred inv6o {
  all t:Teacher | some t.Teaches
}

pred inv7o {
  all c:Class | some Teacher & Teaches.c
}

pred inv8o {
  all t:Teacher | lone t.Teaches
}

pred inv9o {
  all c:Class | lone Teacher & Teaches.c
}

pred inv10o {
  all c:Class,s:Student | some s.(c.Groups)
}

pred inv11o {
  all c:Class | some c.Groups implies some Teacher & Teaches.c
}

pred inv12o {
  all x:Teacher | some x.Teaches.
}

pred inv13o {
  Tutors in Teacher -> Student
}

pred inv14o {
  all c:Class,p:Person | p in (c.Groups).Group implies Teaches.c -> p in Tutors
}

pred inv15o {
  all p:Person | some Teacher & (^Tutors).p
}