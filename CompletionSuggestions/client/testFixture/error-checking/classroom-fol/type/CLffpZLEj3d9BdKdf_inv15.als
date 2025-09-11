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
  all x, y, z : Person | x->y in Tutors and y->z Tutors implies z in Teacher
}


