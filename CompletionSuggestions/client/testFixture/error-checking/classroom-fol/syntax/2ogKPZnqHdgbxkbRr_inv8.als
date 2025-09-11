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
	all t1,t2:Teacher | some c1,c2:Class | t1->c in Teaches and t2->c1 in Teaches implies t1=t2 | 
}

