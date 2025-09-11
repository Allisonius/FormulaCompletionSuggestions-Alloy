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

pred inv13{
  (not some s:Student | all p:Person | s->p in Tutors) and (not some t:Teacher | p->t in Tutors)

}

