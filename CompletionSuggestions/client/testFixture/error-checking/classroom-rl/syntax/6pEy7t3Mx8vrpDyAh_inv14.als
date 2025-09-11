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

pred inv14{
  all c: Class | all s: c.Groups.Group & Student, all t: Teacher | t.Teaches = c implies s in t.Tutors
}

