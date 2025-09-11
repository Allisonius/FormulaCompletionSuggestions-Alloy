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
	all p: Teacher | p.Tutors in Student and p.Teaches in Class.Groupss[Student]
}

