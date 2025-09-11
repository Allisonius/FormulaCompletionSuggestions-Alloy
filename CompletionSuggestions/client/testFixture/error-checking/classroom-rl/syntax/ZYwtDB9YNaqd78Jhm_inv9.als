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
	all c : Class, t, t1 : Teacher | (t->c + t->c1) in Teaches => t = t1 
}

