sig Person  {
	Tutors : set Person,
	Teaches : set Class
}

sig Group {}

sig Class  {
	Groups : Person -> 
}

sig Teacher extends Person  {}

sig Student in Person  {}