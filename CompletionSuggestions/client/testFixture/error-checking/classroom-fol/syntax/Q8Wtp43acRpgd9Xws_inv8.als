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
	all t:Teacher | c1,c2:Class | c1 in t.Teaches and c2 in t.Teaches implies c1=c2
}

