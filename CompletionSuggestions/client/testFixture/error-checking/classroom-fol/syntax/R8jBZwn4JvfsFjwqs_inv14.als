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
  all ps : Person | some c : Class, some g : Group | some t : teacher | c->ps->g in Groups and t->c in Teaches implies t->ps in Tutors
}

