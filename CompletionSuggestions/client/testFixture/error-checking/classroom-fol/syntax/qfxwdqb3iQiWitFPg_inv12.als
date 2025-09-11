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
  	all t: Teacher , x :Class | (some g : Group | x->t->g in Groups) implies t->g in Tutors 

}

