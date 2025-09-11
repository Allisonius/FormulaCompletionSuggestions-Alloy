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
	all c:Class | all t1,t2:Teacher | t->c1 in Teaches and t->c2 in Teaches implies t1=t2
}

