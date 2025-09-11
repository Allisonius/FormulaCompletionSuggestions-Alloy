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
	
  all t1:Teacher,t2:Teacher,c:Class | (t1->c in Teacher and t2->c in Teacher) implies t1=t2
  	
}

