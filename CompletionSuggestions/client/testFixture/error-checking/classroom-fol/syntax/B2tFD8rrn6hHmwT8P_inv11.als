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
  all c : Class, t : Person, g : Group | (t -> c not in Teaches) implies c -> p -> g not in Groups 
}

