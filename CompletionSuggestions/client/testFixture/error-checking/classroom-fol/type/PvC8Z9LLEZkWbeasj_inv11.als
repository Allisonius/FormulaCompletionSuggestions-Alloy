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
    some t : Teacher | all c : Class | some s : Student | some g : Group | c->s->g in Groups and t->c
}

