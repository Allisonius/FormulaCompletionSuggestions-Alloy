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
	all c:Class, t:Person | t->c in Teaches implies {(s->g): c.Groups | t->s in Tutors} 
}

