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
  (all p:Person | p in Teacher) or (all p1,p2:Person | p1->p2 in Tutors implies p2 is Teacher) or (all p1, p2, p3:Person | p1->p2 in Tutors and p2->p3 in Tutors implies p3 in Teacher)
}


