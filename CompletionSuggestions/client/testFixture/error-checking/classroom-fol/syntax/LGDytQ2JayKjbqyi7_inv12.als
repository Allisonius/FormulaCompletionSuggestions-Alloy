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
  
  some x : Class, p: Person, g : Group | x->p->g in Groups implies (lone t : Teacher | t->p in Tutors | p in Student)

}

