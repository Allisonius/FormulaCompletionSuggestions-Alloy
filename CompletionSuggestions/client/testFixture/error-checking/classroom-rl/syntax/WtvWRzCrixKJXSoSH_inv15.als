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
  
  all p1: Person | (p1 not in Teacher implies (some p2:Person | p2->p1 in Tutors)
}


