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

pred inv15{
	all p : Person | some t : Teacher | t->p in Tutors or (some q : Person | q->p in Tutors and t->q in tutors)
}


