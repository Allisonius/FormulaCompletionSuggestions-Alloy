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

pred inv14{
	all p1, p2 : Person, c : Class | (some g : Group | c -> p2 -> g in Groups) and p1 -> c in Teaches implies p1 -> p2 in Tutors) 
}

