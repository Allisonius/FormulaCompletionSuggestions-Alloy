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
	all p : Person | some q : Person, t : Teacher | t->p in Tutors or (q->p in Tutors and t->q in Tutors) or (t->q in Tutors and q->p in Tutors and r->t in Tutors)
}


