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
  all c : Class, g : Group, p1, p2 : Person | (p1->c in Teaches and c->p2->g) implies (p1->p2 in Tutors)
}

