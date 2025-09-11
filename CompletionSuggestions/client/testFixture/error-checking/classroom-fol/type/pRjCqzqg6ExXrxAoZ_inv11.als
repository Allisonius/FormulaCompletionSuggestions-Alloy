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

  	all c:Class |some t:Teacher |some g:Groups|  no c implies no (t->c in Teaches )
  
}

