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
	all p : Person | some p1 : Person | p1 -> p2 in Tutors implies p2 in Teacher
}


