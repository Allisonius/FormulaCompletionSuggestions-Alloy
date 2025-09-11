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

pred inv12{

  all t : Teacher, c : Class  | t -> c in Teaches implies (some p : People, g : Group | c -> p -> g in Groups)


}

