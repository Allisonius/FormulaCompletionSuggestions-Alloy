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
	all s, t : Person | some s.(Class.Groups) and some t<:Teaches implies some t.(Tutors.s)
}

