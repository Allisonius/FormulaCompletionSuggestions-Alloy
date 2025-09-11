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
	all p1 | (p1 in Teacher) or 
  (some p2 | (p2 != p1) and (p2->p1 in Tutors) and ((p2 in Teacher) or
  (some p3 | (p3 != p2) and (p3 != p1) and (p3 in Teacher))))
}


