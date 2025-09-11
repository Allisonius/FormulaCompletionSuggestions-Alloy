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
	all p1,p2,p3 : Person
  		| p1 in Teacher or
  		| (p2->p1 in Tutors and p2 in Teacher) or
  		| (p3->p2 in Tutors and p2->p1 Tutors and p3 in Teacher)
}


