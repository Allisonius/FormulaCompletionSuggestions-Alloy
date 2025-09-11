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

pred inv13{  all f,l,u : File | f->l in link and f->u in link implies l = u 
  all p1,p2 : Person | p1->p2 in Tutors implies p1 in Teacher and p2 in Student
}

