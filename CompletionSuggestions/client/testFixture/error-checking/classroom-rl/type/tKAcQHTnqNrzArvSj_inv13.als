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
	all t, s : Person | (t.Tutors & s.Tutors) implies (t in Teacher & s in Student)
}

