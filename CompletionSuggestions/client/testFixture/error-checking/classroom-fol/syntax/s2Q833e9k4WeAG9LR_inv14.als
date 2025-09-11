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
  all x : Person, y : Class, v : Teacher | (some z : Group | y->x->z in Groups) and v->y in Teaches implies v->x in Tutor

