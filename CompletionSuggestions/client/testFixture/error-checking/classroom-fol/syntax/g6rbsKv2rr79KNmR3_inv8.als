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
  some t1:Teacher , t2:Teacher | (t1->c in Teaches and t2->c in Teaches) implies t1 = t2 or (not t1-> and not t2->c)
}

