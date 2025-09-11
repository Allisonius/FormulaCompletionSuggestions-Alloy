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
	all c : Class, p, p2 : Person | p -> c in Teaches and p in Teacher implies some g : Group | c -> p2 -> g
}

