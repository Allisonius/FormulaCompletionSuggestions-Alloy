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
  
  lone t : Teacher | some g : Group, p : Person | p -> g in Groups implies t->p in Tutors

}

