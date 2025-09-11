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
   c : Class, disj t1,t2 : Teacher | not c in (t1.Teaches & t2.Teaches)

}

