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

pred inv11{
	(some c : Class, t : Teacher | t -> c in Teaches) implies (all g : Group, p : Person | c -> p -> g in Groups)
}

