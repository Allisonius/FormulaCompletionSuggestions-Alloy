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

	all c : Class | t1, t2 : Teacher | t1 in Teaches.c & t2 in Teaches.c -> t1=t2
}

