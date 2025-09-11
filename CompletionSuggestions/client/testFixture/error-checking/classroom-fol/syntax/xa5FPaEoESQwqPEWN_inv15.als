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

pred inv15{
  some x, y, z : Person | x->y in Tutors and y->z in Tutors implies z in Teachers

}


