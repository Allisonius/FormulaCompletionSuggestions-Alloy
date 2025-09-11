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
  all p : Person | aux1[p]
}

pred aux1[p : Person]{
  p in Teacher or (all p2 : Person | p2 -> p in Tutors and aux1[p2])
}


