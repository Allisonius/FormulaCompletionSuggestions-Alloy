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
	
	all c : Class, p, p1 : Persons | some g : Group | p -> c not in Teaches or p not in Teacher) implies c -> p1 -> g not in Groups 
}

