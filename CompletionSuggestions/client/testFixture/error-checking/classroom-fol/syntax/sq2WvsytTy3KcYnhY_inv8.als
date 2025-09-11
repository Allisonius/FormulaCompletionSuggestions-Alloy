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
all t : Teacher | (some x,y : Class | t->x in Teaches and t->y in Teaches) implies x=y
}

