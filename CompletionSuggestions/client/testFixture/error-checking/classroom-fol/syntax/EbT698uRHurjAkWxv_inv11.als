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
	all c:Class | (some g:Group | some t:Teacher | c->(t->g) in Groups) implies t->c in Teaches
}

