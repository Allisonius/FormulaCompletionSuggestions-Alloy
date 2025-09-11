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
 	all c : Class, s : c.Groups.Student, t : Teacher->c | t->s in Tutors 
}

