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
	all p1, p2, p2 : Person | (p1 -> p2 in Tutors implies p2 in Tutors) or (p1 -> p2 and p2 -> p3 implies p3 in Tutors)
}


