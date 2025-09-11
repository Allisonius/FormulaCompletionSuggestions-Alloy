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

pred inv13{
  all p : Person | some p.Tutors implies p in Teachers  and p.Tutors in Student 

}

