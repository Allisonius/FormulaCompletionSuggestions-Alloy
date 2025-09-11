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
	all c : Class, p : Person, g : Group | p -> c in Teaches and p in Teacher implies c -> t -> g in Groups
}

