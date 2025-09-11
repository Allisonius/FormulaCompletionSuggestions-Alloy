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
	all p1, p2:Person |
  	
  	((p2->p1 in Tutors and p2 in not in Teacher) implies some p3:Person | p3->p2 in Tutors) 
  	
  	
}


