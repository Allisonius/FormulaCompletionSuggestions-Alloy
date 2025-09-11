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
	Student in Student.(Class.Groups) and Class in (Teacher<:Teaches).Class implies some (Teacher:>Tutors).Student
}

