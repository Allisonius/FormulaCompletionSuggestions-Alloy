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

pred inv12{
  	
	all t: Teacher | some  c: Class | some g: Group | all p: Person |  t->c in Teaches implies c->p->g in Groups and c->t->g
}

