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

pred inv10{
	all x : Class | (some p : Person, g : Group | x->p->g in Groups) -> 
(some t : Teacher | t->x in Teaches)
}

