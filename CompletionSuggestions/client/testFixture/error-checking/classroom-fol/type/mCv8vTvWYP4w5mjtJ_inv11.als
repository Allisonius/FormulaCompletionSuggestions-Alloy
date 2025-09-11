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
 	all c: Class, s: Student | some t: Teacher, g: Groups | (c->t not in Teaches) implies c->s->g not in Groups
}

