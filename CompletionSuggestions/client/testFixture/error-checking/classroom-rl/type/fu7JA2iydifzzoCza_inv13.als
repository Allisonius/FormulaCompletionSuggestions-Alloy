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
	
  	all t,s:Person | Tutors.s:>t implies t in Teacher and s in Student
}

