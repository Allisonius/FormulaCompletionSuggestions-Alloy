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
	Class->Teacher->Group in Groups
}

run test { inv5 and not inv5O}

pred inv5{
	Class->Teacher->Group in Groups
}

run test { inv5 and not inv5O}

