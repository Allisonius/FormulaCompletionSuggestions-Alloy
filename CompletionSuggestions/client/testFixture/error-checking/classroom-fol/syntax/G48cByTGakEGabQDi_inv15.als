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
	all t,s1,s2:Person | all c:Class | all g:Group | c->(s1->g) in Groups and c->(s2->g) in Groups and t->c in Teaches) implies (t->s1 in Tutors and t->s2 in Tutors)
}


