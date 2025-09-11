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
	all t : Teacher, c : Class, s : Student, g : Group | t -> c in Teaches and c -> s -> g in Groups implies t -> p in Tutors
}

