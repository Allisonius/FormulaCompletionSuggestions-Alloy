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
	all p : Person | some c : Class, g : Group | c->p->g in Groups implies some t->p in Tutors and t : Teacher | t->c in Teaches
}

