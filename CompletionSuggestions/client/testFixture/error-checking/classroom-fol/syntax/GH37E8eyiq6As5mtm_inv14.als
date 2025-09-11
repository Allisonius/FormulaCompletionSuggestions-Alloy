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
  all x : Person | some y : Class | (some z : Group | c->x->z in Groups) implies all u : Teacher | u->y in Teaches and u->x in Tutors
}

