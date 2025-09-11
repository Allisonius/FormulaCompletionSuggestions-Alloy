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

pred inv9{
  	all c : Class | all p1, p2 : Person | p1, p2 in Teacher and p1 -> c in Teaches and p2 -> c in Teaches => p1 = p2
}

