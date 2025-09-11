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
	
	not some c:Class, t:Teacher | s:Student, g:Group | t->c not in Teaches and  c->s->g in Groups
}

