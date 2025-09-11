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
  all x : Class | some y : Person, z : Group, v : Teacher | x->y->z in Group implies v->x in Teaches
}

