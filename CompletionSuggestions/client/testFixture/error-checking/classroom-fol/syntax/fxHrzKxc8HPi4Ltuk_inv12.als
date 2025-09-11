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
	all t: Teacher | all  c: Class | some g: Group | c->t->g in Groups implies p in Teacher and t->c in Teaches
}

