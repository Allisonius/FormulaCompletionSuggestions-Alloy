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
	(all t:Teacher | some c:Class | t->c in Teaches implies (some s:Student,g:Group | c->s->g in Groups)
}

