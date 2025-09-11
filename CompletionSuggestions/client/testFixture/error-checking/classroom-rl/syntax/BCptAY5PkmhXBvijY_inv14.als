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
	Student in (c.Groups) and Class in (t<:Teaches) implies Student in (t<:Tutors)
}

