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

pred inv8{
  all c1:Class,c2:Class,t:Teacher | (t->c1 in Teaches implies not t1->c2 in Teaches
}

