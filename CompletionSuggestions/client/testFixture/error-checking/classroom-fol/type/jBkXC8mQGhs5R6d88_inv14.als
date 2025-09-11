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
  all t : Teacher | some c : Class, s : Person, g : Groups | t->c in Teaches and c->s->g in Groups implies t->s in Tutors
}

