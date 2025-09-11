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
all p1,p2,p3:Person | (p1 in Teacher implies (p2 and p3 in  Student) )or (p2 in Teacher implies (p1 and p3 in  Student) ) or (p3 in Teacher implies (p2 and p1 in  Student) )
}


