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

pred inv12{
  all t : Teacher, c : Class | some g : Group, p : Person | c->p in Group implies t->c in Teaches
 
}

