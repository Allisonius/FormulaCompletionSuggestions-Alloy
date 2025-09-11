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

  	all c:Class | some t:Teacher |some g:Groups| g in c implies t->c in Teaches 
  
}

