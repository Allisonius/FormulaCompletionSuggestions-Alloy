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

pred inv13{
	(some p1:Person, p2:Person | p1 -> p2 in Tutors) iff (p1 in Teacher and p2 in Student)
}

