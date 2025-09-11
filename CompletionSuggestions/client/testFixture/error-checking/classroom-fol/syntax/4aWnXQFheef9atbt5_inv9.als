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

pred inv9{
	all t1:Teacher, t2:Teacher, c:Classe | (t1->c in Teaches and t2->c in Teaches) implies t1=t2
}

