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
	
  	
  	all c:Class | some t:Teacher,g:Group | some c.Groups implies t in c->g in ~Groups
}

