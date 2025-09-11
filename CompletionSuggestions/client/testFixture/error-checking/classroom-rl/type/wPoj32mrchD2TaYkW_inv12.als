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
	 iden in  (~Teaches.~Groups :> Teacher) . (Teacher <: Teaches.Groups)
}

