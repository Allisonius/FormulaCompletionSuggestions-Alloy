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

pred inv5{
	some c:Class | hasTeacher[c] 
}

pred hasTeacher[c:Classes]{
	all g:Group | group_has_teacher[g]
}

