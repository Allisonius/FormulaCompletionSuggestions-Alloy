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
  all x : Person, y : Class | (some z : Group | y->x->z in Groups) and (all u : Teacher | u->y in Teaches) implies u->x in Tutors
}

