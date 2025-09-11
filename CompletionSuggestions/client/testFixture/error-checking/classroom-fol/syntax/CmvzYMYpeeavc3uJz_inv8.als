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

pred inv8{
	all t : Teacher c,d:Class | t->c in Teaches and t->d in Teaches implies c=d
}

