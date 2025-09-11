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
	all p : Person | p in Teacher or
  		(some p2 : Person | (p2->p1 in Tutors and p2 in Teacher))
  			
}


