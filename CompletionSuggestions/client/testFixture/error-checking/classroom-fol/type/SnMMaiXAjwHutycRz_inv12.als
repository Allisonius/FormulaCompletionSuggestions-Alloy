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

pred inv12{
	(some c : Class | all t : Teacher | t->c in Class implies some g : Group, s : Student | c->s->g in Groups)
}

