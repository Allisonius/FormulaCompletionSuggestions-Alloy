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
	all s:Person | all c:Class | all g:Group | (c->(s->g) in Groups implies (all t:Teacher | t->c in Teaches implies t->s in Tutors
}


