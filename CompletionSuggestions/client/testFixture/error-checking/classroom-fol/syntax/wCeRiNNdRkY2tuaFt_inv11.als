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
	all p:Person, c:Class | (some t:Teacher, g:Group | c->p->g in Groups implies t->c in Teaches 
}

