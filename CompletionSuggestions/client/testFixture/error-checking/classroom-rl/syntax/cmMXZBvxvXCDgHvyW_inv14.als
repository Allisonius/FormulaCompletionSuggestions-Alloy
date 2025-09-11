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

pred inv14{
	some c:Class |all t:Teacher | t->c in. Teaches implies {(s,g): c.Groups | t->s in Tutors} 
}

