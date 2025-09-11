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
  
  some x : Class | (some p: Person g : Group | x->p->g in Groups) implies (lone t : Teacher | t->x in Teaches)

}

