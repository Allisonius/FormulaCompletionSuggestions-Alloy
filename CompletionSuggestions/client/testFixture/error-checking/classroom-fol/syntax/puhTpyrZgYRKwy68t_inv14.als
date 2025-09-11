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
	all p1 : Student, some t : Teacher | (all c: Class, some g: Group | c->g->p1) => t->p1 in Tutors
}

