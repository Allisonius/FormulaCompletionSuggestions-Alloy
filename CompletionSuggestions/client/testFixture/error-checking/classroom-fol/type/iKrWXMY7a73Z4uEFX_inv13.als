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
	
  	
  	
  	
  	all s:Student, t:Teacher | s not in Person.Tutors.^Tutors and t not in Person.~Tutors^~Tutors
}

