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

pred inv3{
	(Person in Student and Person not in Teacher) or (Person not in Student and Person in Teacher) or (Person not in Student and Person not in Teacher)
}
}

