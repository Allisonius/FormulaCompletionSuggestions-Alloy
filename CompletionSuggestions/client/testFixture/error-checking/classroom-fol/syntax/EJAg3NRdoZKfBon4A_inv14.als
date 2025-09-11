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
	all c : Class | some s : Student, g : Group | c->p->g in Groups implies some t : Teacher | t->s in Tutors 
}

