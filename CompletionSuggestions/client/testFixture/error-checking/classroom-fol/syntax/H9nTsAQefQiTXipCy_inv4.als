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

pred inv4{
  	always (all p:Person | (p in Student implies p not in Teacher) and (p in Teacher implies p not in Student)
}

