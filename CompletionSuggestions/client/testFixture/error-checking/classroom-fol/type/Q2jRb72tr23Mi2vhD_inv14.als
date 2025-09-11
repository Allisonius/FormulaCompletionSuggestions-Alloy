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
  all s : Student, c : Class | some t : Teacher | c->s in Groups implies t->s in Tutors
}

