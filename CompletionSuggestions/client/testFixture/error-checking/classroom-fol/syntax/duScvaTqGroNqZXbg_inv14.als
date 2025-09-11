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
  all t : Teacher | some c : Class | t->c in Teaches and (some g : Group, s : Person | c->s->g in Groups) implies t-> s in Tutors
}

