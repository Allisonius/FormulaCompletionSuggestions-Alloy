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
	all some c :Class | all t1,t2 : Teacher | (t1->c in Teaches and t2->c in Teaches) => t1 = t2
}

