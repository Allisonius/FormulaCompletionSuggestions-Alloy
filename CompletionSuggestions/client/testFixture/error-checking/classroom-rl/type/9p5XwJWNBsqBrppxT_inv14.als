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
	all p:Person, c:Class| some t:Teacher, g:Group |t->c  and c->p->g in Groups implies t->p in Tutors
}

