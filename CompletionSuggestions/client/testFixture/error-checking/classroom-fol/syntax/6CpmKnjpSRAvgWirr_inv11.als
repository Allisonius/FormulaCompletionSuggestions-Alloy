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
	all c : Class | (some s : Student | some g : Group | some t : Teacher | c->s->g in Groups) => t->c in Teaches
}

