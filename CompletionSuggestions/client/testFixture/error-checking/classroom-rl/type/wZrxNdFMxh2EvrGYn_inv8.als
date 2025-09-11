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
	all t : Teacher, c, c1 : Class | t->c in Teaches & t->c1 in Teaches => c = c1 
}

