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
	some p1, p2:Person | p1 -> p2 in Tutors implies (p1 in Teacher or  p2 in Teacher or (some p3:Person | p2 -> p3 in Tutors implies p3 in Teacher)
}


