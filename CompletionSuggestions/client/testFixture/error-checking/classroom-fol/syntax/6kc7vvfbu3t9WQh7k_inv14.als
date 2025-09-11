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
	all p : Person | some c : Class, g : Group, t : Teacher | (c->s->g in Groups and t->c in Teaches) and t->s in Tutors
}

