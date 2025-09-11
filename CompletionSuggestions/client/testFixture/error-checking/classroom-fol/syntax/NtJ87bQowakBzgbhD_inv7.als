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

pred inv7{
  all x : Class | some p : Person, g : Group . x->p->g in Group implies (some t : Teacher | t->x in Teacher)
}

