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

pred inv11{
  
  all g:Group | some p:Person | p->g in Groups 
  
	
  
  
  
 
  
 
  
}

