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
	all x : Class, p:Person, g:Group | some x->p->g in Class implies p->g in Teacher 
}

