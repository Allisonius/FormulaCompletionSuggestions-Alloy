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
	all p1:Person, p2:Person | p1 in Tutors.Person implies p1 in Teacher && p2 in Tutors implies p2 in Student
}

