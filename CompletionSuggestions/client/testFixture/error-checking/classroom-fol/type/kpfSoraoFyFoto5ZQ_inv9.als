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

pred inv9{
  	
  
  	
  	all t:Teacher,c:Class | (lone t.Teaches) and (lone c->t in Groups)
  	
}

