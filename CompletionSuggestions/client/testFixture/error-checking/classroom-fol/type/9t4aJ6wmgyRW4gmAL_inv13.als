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
	all p1, p2 : Person, ps : set Person | (p1->ps in Tutors and p2 in Tutors) => (p1 in Teacher and p2 in Student)
}

