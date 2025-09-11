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

	all c : Class | some t1, t2 : Teacher | t1 in Teaches.c and t2 in Teaches.c -> t1=t2
}

