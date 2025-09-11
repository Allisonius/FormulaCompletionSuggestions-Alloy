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
	all p : Person | some q,r : Person | (p->q in Tutors or q->p in tutors or p->r in Tutors or r->p in Tutors)
  											implies (p in Teacher or q in Teacher or r in Teacher)
}


