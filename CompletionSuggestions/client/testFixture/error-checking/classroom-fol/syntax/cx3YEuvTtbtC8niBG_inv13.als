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
	all p1:Person | isTutored [p1] implies p1 in Student
}

pred isTutored (p1:Person){
	some p2:Person | p1->p2 in Tutors

