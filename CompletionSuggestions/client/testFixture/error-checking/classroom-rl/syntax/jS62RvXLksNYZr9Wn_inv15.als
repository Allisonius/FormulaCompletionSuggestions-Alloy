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
	
    
  	
  	
  all p1:Person | some p2:person | p2->p1 in Tutors
  
}


