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
  all c : Class | some g : Group | all t, p : Person | (c->p->g in Groups and t->g in Group) implies (t->c in Teaches and t in Teacher)
 
}

