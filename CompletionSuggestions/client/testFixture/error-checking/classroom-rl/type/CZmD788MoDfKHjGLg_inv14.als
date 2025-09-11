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
  all s : Student, c : Class | c -> s <: Groups implies (Teaches . c) -> s in Tutors
}

