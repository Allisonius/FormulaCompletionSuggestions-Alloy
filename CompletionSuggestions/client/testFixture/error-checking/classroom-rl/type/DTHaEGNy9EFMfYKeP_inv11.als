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

pred inv11{
  
	all c : Class, t : Teacher | no (t->c in Teacher->Teaches) => no c.Groups
}

