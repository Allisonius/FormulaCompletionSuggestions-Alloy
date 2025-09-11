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
  all p1: Person | p1 in Teacher or (some p2:Person | p1->p2 in Tutors => (p2 in Teacher or (some p3:Person | p2->p3 in Tutors andp3 in Teacher)))
}


