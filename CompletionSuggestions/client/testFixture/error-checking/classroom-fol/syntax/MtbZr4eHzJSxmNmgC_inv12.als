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
	Teaches in Teacher -> some Class | some c:Class, s:Student, g:Group | c -> s -> g in Groups
}

