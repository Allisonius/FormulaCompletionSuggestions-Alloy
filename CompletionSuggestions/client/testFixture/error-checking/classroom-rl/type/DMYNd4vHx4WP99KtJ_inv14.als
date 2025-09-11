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
	all s:Person,c:Class | some (c<:Groups.s) implies (all t:Person | some Teaches.c:>t implies Tutors.s:>t)
}

