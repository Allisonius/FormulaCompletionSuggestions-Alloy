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
  all g: Group | some c: Class | all t: Teacher | c->t->g in Groups g in Student implies t->g in Tutors
}

