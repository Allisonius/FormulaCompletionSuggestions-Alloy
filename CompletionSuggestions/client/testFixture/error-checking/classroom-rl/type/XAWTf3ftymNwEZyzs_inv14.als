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
 	all c : Class, p : c.Groups.Person, t : Teacher->c | p in t.Tutors
}

