sig Person  {
	Tutors : set Person,
	Teaches : set Class
}
sig Group {}

sig Class  {
	Groups : Person -> Group
}

sig Teacher in Person  {}

sig Student in Person  {}

pred inv15{
  all p : Person {
    (some (p.~Tutors) & Teacher)) or (some (p.~Tutors.~Tutors) & Teacher)) or (some (p.~Tutors.~Tutors.~Tutors) & Teacher))
  }
}


