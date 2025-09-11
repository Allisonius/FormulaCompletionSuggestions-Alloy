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
  all p,t : Person | c : Class, g : Group | t->p in Tutors implies t->c in Teaches and c->p->g in Groups
}

